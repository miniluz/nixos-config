{
  pkgs,
  lib,
  baseUrl,
  proxies,
}:
pkgs.writeTextFile {
  name = "homepage";
  destination = "/index.html";
  text = ''
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8">
        <title>Home Server</title>
        <script>
          document.addEventListener('DOMContentLoaded', async () => {
            async function findFavicon(url) {
              try {
                const u = new URL(url);
                const origin = u.origin;
                const icoUrl = origin + '/favicon.ico';
                let res = await fetch(icoUrl, { method: 'HEAD' });
                if (res.ok) return icoUrl;

                res = await fetch(url);
                if (!res.ok) return null;
                const html = await res.text();

                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const links = doc.querySelectorAll('link[rel~="icon"]');

                for (const link of links) {
                  let href = link.getAttribute('href');
                  if (!href) continue;
                  if (href.startsWith('/')) href = origin + href;
                  else if (!/^https?:\/\//i.test(href)) href = origin + '/' + href;
                  return href;
                }

                return null;
              } catch (err) {
                console.warn('Failed to fetch favicon for', url, err);
                return null;
              }
            }

            document.querySelectorAll('img.favicon').forEach(async (img) => {
              const domain = img.dataset.domain;
              const url = 'https://' + domain;
              const favicon = await findFavicon(url);
              if (favicon) img.src = favicon;
            });
          });
        </script>
        <style>
          /* Catppuccin Mocha inspired dark theme */
          body {
            font-family: "Fira Code", monospace;
            background: #1e1e2e;
            color: #cdd6f4;
            margin: 2rem;
          }
          h1 {
            text-align: center;
            color: #f5c2e7;
            font-size: 2.5rem;
          }
          ul {
            list-style: none;
            padding: 0;
            max-width: 500px;
            margin: 2rem auto;
          }
          li {
            background: #313244;
            margin: 0.5rem 0;
            padding: 1rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.5);
            transition: transform 0.2s, box-shadow 0.2s;
          }
          li:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.6);
          }
          a {
            text-decoration: none;
            color: #89b4fa;
            font-weight: bold;
            margin-left: 0.5rem;
            flex: 1;
          }
          img.favicon {
            width: 24px;
            height: 24px;
            border-radius: 0.25rem;
          }
        </style>
      </head>
      <body>
        <h1>💻 Home Server Services</h1>
        <ul>
          ${lib.concatStringsSep "\n" (
            map (s: ''
              <li>
                <img class="favicon" data-domain="${s.name}.${baseUrl}">
                <a href="https://${s.name}.${baseUrl}" title="https://${s.name}.${baseUrl}">${s.name}</a>
              </li>
            '') proxies
          )}
        </ul>
      </body>
    </html>
  '';
}
