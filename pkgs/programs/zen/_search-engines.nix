{
  Default = "sx";
  Add = [
    # ==== SEARCH ENGINES ====
    {
      Name = "SearXNG";
      URLTemplate = "https://searxng.home.miniluz.dev/search?q={searchTerms}";
      IconURL = "https://searxng.home.miniluz.dev/static/themes/simple/img/favicon.png";
      Alias = "@sx";
    }
    {
      Name = "Wikipedia (English)";
      URLTemplate = "https://en.wikipedia.org/w/index.php?search={searchTerms}";
      IconURL = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
      Alias = "@wen";
    }
    {
      Name = "Wikipedia (Español)";
      URLTemplate = "https://es.wikipedia.org/w/index.php?search={searchTerms}";
      IconURL = "https://es.wikipedia.org/static/favicon/wikipedia.ico";
      Alias = "@wes";
    }

    # ==== DICTIONARIES ====
    {
      Name = "Merriam-Webster";
      URLTemplate = "https://www.merriam-webster.com/dictionary/{searchTerms}";
      IconURL = "https://www.merriam-webster.com/favicon.ico";
      Alias = "@mw";
    }
    {
      Name = "RAE";
      URLTemplate = "https://dle.rae.es/{searchTerms}";
      IconURL = "https://dle.rae.es/favicon-16x16.png";
      Alias = "@rae";
    }

    # ==== NIX ====
    {
      Name = "nixpkgs packages";
      URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
      IconURL = "https://wiki.nixos.org/favicon.ico";
      Alias = "@np";
    }
    {
      Name = "NixOS options";
      URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
      IconURL = "https://wiki.nixos.org/favicon.ico";
      Alias = "@no";
    }
    {
      Name = "NixOS Wiki";
      URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
      IconURL = "https://wiki.nixos.org/favicon.ico";
      Alias = "@nw";
    }
    {
      Name = "noogle";
      URLTemplate = "https://noogle.dev/q?term={searchTerms}";
      IconURL = "https://noogle.dev/favicon.ico";
      Alias = "@ng";
    }

    # ==== PACKAGE REGISTRIES ====
    {
      Name = "npm-packages";
      URLTemplate = "https://www.npmjs.com/search?q={searchTerms}";
      IconURL = "https://www.npmjs.com/favicon.ico";
      Alias = "@npm";
    }
    {
      Name = "cargo-packages";
      URLTemplate = "https://lib.rs/search?q={searchTerms}";
      IconURL = "https://lib.rs/favicon.ico";
      Alias = "@rs";
    }
  ];
}
