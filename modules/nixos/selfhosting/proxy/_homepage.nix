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
          body {
            font-family: "Fira Code", monospace;
            margin: 0;
            padding: 2rem;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #cdd6f4;
            overflow: hidden;
            background: #0f0f14;
            position: relative;
          }

          /* Nebula effect */
          body::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background:
              radial-gradient(circle at 20% 30%, #ff79c6 0%, transparent 60%),
              radial-gradient(circle at 70% 20%, #8be9fd 0%, transparent 50%),
              radial-gradient(circle at 40% 70%, #50fa7b 0%, transparent 60%);
            background-size: 200% 200%;
            filter: blur(120px);
            animation: moveNebula 30s linear infinite, rotateNebula 60s linear infinite;
            z-index: -1;
          }

          @keyframes moveNebula {
            0% { background-position: 0% 0%, 0% 0%, 0% 0%; }
            50% { background-position: 20% 30%, 30% 20%, 10% 40%; }
            100% { background-position: 0% 0%, 0% 0%, 0% 0%; }
          }

          @keyframes rotateNebula {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }

          h1 {
            text-align: center;
            color: #f5c2e7;
            font-size: 2.5rem;
            margin-top: 2rem;
            margin-bottom: 0.5rem;
            text-transform: lowercase;
            z-index: 1;
          }

          h2 {
            text-align: center;
            color: #f5e0dc;
            font-weight: normal;
            margin-bottom: 2rem;
            z-index: 1;
          }

          ul {
            list-style: none;
            padding: 0;
            max-width: 500px;
            width: 90%;
            z-index: 1;
          }

          li {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            font-size: 1.25rem;
            margin: 0.5rem 0;
            opacity: 0;
            animation: fadeInUp 0.5s forwards;
            transition: transform 0.2s;
          }

          li:hover {
            transform: translateX(8px) scale(1.05);
          }

          li a {
            text-decoration: none;
            color: #89b4fa;
            margin-left: 0.5rem;
            transition: text-shadow 0.3s, color 0.3s;
            text-shadow: 0 0 1px #4f5b75;
          }

          li a:hover {
            text-shadow: 0 0 3px #89b4fa;
            color: #a6c1ff;
          }

          li::before {
            content: ">";
            color: #f5c2e7;
            margin-right: 0.5rem;
          }

          @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
          }

          @media (max-width: 600px) {
            h1 { font-size: 2rem; }
            li { font-size: 1rem; }
          }
        </style>
      </head>
      <body>
        <h1>nebula quick access</h1>
        <h2>to space and beyond...</h2>
        <ul id="services-list">
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

        <script>
          // Staggered fade-in via JS
          const listItems = document.querySelectorAll('#services-list li');
          listItems.forEach((li, index) => {
            li.style.animationDelay = `''${index * 0.02}s`;
          });
        </script>
      </body>
    </html>
  '';
}
