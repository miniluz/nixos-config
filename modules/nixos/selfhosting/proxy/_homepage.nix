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
            background: #0f0f14; /* darker base */
            margin: 0;
            padding: 2rem;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #cdd6f4;
            overflow: hidden;
            position: relative;
          }

          /* Morphing noisy shapes */
          body::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 30%, #302d41 0%, #0f0f14 70%);
            animation: rotateGradient 20s linear infinite, morphShape 25s ease-in-out infinite alternate;
            z-index: -1;
            filter: blur(100px);
            clip-path: polygon(
              30% 10%, 70% 20%, 80% 50%, 60% 80%, 30% 70%, 10% 40%
            );
          }

          @keyframes rotateGradient {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }

          @keyframes morphShape {
            0% { clip-path: polygon(30% 10%, 70% 20%, 80% 50%, 60% 80%, 30% 70%, 10% 40%); }
            50% { clip-path: polygon(25% 15%, 75% 25%, 85% 55%, 65% 85%, 35% 65%, 15% 45%); }
            100% { clip-path: polygon(30% 10%, 70% 20%, 80% 50%, 60% 80%, 30% 70%, 10% 40%); }
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
          }

          li a {
            text-decoration: none;
            color: #89b4fa;
            margin-left: 0.5rem;
            transition: text-shadow 0.3s, color 0.3s;
            text-shadow: 0 0 2px #4f5b75;
          }

          li a:hover {
            text-shadow: 0 0 4px #89b4fa;
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

          /* Responsive for mobile */
          @media (max-width: 600px) {
            h1 { font-size: 2rem; }
            li { font-size: 1rem; }
          }

        </style>
      </head>
      <body>
        <h1>💻 home server services</h1>
        <h2>quick access to all your home services</h2>
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
          // Apply staggered fade-in animation dynamically
          const listItems = document.querySelectorAll('#services-list li');
          listItems.forEach((li, index) => {
            li.style.animationDelay = `''${index * 0.1}s`;
          });
      </script>

      </body>
    </html>
  '';
}
