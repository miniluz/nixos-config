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
        <style>
          body {
            font-family: sans-serif;
            background: #f8f9fa;
            color: #333;
            margin: 2rem;
          }
          h1 {
            text-align: center;
          }
          ul {
            list-style: none;
            padding: 0;
            max-width: 400px;
            margin: 2rem auto;
          }
          li {
            background: white;
            margin: 0.5rem 0;
            padding: 1rem;
            border-radius: 0.5rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          a {
            text-decoration: none;
            color: #007acc;
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        <h1>Home Server Services</h1>
        <ul>
          ${lib.concatStringsSep "\n" (
            map (s: "<li><a href=\"https://${s.name}.${baseUrl}\">${s.name}</a></li>") proxies
          )}
        </ul>
      </body>
    </html>
  '';
}
