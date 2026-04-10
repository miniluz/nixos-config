use std::{collections::HashMap, fs, io};

use chrono::{DateTime, Utc};
use clap::Parser;
use eyre::{Context, eyre};
use facet::Facet;
use facet_pretty::FacetPretty;
use ureq::{
    config::Config,
    http::Uri,
    tls::{TlsConfig, TlsProvider},
    unversioned::multipart::{Form, Part},
};

#[derive(Parser, Facet)]
#[command()]
struct Args {
    channel: String,

    #[arg(help = "File to use for the body. Use - to use stdin.")]
    text: String,

    #[arg(short, long)]
    title: Option<String>,

    #[arg(short, long, default_value = "e74c3c")]
    color: String,

    #[arg(short, long)]
    attach: Vec<String>,

    #[arg(short, long)]
    notify: bool,
}

#[derive(Facet)]
struct Webhooks {
    webhooks: HashMap<String, String>,
}

#[derive(Facet)]
struct WebhookBody {
    content: Option<String>,
    embeds: Option<Vec<WebhookBodyEmbeds>>,
}

#[derive(Facet)]
struct WebhookBodyEmbeds {
    title: Option<String>,
    description: Option<String>,
    color: Option<i64>,
    timestamp: Option<DateTime<Utc>>,
}

fn main() -> eyre::Result<()> {
    color_eyre::install()?;

    let args = Args::parse();

    println!("Arguments received: {}", args.pretty());

    let webhook: Uri = {
        let webhook_file = std::env::var("WEBHOOK_FILE")
            .wrap_err("WEBHOOK_FILE environment variable must be set.")?;
        let webhook_file_contents = fs::read_to_string(&webhook_file).wrap_err(format!(
            "Failed to read file specified by WEBHOOK_FILE: {}",
            &webhook_file
        ))?;
        let webhooks: Webhooks = facet_json::from_str(&webhook_file_contents)?;

        let webhook_url = webhooks
            .webhooks
            .get(&args.channel)
            .ok_or(eyre!("Failed to get webhook for channel {}", args.channel))?
            .to_string();

        format!("{}?wait=true", webhook_url)
            .parse()
            .wrap_err(format!(
                "Webhook URL was not a valid URL for channel {}",
                args.channel
            ))?
    };

    let description = if &args.text == "-" {
        io::read_to_string(io::stdin())
            .context("Failed to read text from STDIN as specified in text flag")?
    } else {
        fs::read_to_string(&args.text).context(format!(
            "Failed to read text from file specified in text flag: {}",
            &args.text
        ))?
    };

    let color = i64::from_str_radix(&args.color, 16).wrap_err(format!("Failed to convert color to integer, a hex without a prefix was expected (e.g. ffffff) for color {}", &args.color))?;

    let timestamp = Utc::now();

    let content = if args.notify {
        Some("@everyone".to_string())
    } else {
        None
    };

    let payload_json = WebhookBody {
        content,
        embeds: Some(vec![WebhookBodyEmbeds {
            title: args.title,
            color: Some(color),
            description: Some(description),
            timestamp: Some(timestamp),
        }]),
    };
    let payload_json = &facet_json::to_string(&payload_json)?;

    let form = Form::new();

    let json_part = Part::text(&payload_json).mime_str("application/json")?;
    let mut form = form.part("payload_json", json_part);

    let names: Vec<String> = args
        .attach
        .iter()
        .enumerate()
        .map(|(i, _)| format!("files[{}]", i))
        .collect();

    for (name, filename) in names.iter().zip(args.attach.iter()) {
        form = form.part(
            name,
            Part::file(&filename).wrap_err("Failed to read attachment")?,
        );
    }

    let config = Config::builder()
        .tls_config(
            TlsConfig::builder()
                .provider(TlsProvider::NativeTls)
                .build(),
        )
        .build();

    let agent = config.new_agent();

    let mut response = agent
        .post(webhook.clone())
        .send(form)
        .wrap_err(format!("Failed to fetch webhook at URI {}", webhook))?;

    if !response.status().is_success() {
        Err(eyre!(
            "Fetching webhook failed with status {}: {}",
            response.status(),
            response
                .body_mut()
                .read_to_string()
                .wrap_err("Failed to get text")?
        ))?;
    }

    Ok(())
}
