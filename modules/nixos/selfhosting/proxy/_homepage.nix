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
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>home server</title>
        <style>
          /* Catppuccin Mocha inspired dark theme */
          body {
            font-family: "Fira Code", monospace;
            background: linear-gradient(120deg, #1e1e2e, #302d41, #1e1e2e);
            background-size: 600% 600%;
            animation: gradientBG 15s ease infinite;
            color: #cdd6f4;
            margin: 0;
            padding: 2rem;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
          }

          @keyframes gradientBG {
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
          }

          h1 {
            text-align: center;
            color: #f5c2e7;
            font-size: 2.5rem;
            margin-top: 2rem;
            margin-bottom: 0.5rem;
            text-transform: lowercase;
          }

          h2 {
            text-align: center;
            color: #f5e0dc;
            font-weight: normal;
            margin-bottom: 2rem;
          }

          ul {
            list-style: none;
            padding: 0;
            max-width: 500px;
            width: 90%;
          }

          li {
            background: #313244;
            margin: 0.5rem 0;
            padding: 1rem;
            border-radius: 0.5rem;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.5);
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
          }

          li:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 15px rgba(0,0,0,0.7);
          }

          a {
            text-decoration: none;
            color: #89b4fa;
            font-weight: bold;
            text-align: center;
            display: inline-block;
            text-shadow: 0 0 2px #89b4fa;
            transition: text-shadow 0.2s;
          }

          li:hover a {
            text-shadow: 0 0 8px #89b4fa, 0 0 16px #89b4fa;
          }

          img.favicon {
            width: 24px;
            height: 24px;
            border-radius: 0.25rem;
            margin-right: 0.5rem;
          }

          /* Responsive for mobile */
          @media (max-width: 600px) {
            h1 {
              font-size: 2rem;
            }
            li {
              padding: 0.75rem;
            }
          }
        </style>
      </head>
      <body>
        <h1>💻 home server services</h1>
        <h2>quick access to all your home services</h2>
        <ul>
          ${lib.concatStringsSep "\n" (
            map (s: ''
              <li>
                <a href="https://${s.name}.${baseUrl}" title="https://${s.name}.${baseUrl}">
                  ${s.name}
                </a>
              </li>
            '') proxies
          )}
        </ul>
      </body>
    </html>
  '';
}
