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
          const baseNames = ['favicon', 'logo'];
          const pngSizes = ['128x128', '64x64', '32x32', '16x16'];
          const extensions = ['svg', 'png', 'ico'];

          function generateFaviconVariants() {
            let variants = [];

            for (const name of baseNames) {
              for (const ext of extensions) {
                if (ext === 'svg') {
                  variants.push(name + '.svg');
                } else if (ext === 'png') {
                  for (const size of pngSizes) {
                    variants.push(name + '-' + size + '.png');
                  }
                } else if (ext === 'ico') {
                  variants.push(name + '.ico');
                }
              }
            }

            return variants;
          }

          const faviconVariants = generateFaviconVariants();

          function tryFavicon(img, baseUrl) {
            let index = 0;

            function next() {
              if (index >= faviconVariants.length) return;
              img.src = baseUrl + '/' + faviconVariants[index];
              index++;
            }

            img.onerror = next;
            next(); // start with the first one
          }
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
                <img class="favicon" src="https://${s.name}.${baseUrl}/favicon.svg" 
                     onerror="tryFavicon(this, 'https://${s.name}.${baseUrl}')">
                <a href="https://${s.name}.${baseUrl}" title="https://${s.name}.${baseUrl}">${s.name}</a>
              </li>
            '') proxies
          )}
        </ul>
      </body>
    </html>
  '';
}
