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
        <title>Modular Multi-Layer Noise Cloud Background</title>
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
          body::before {
          content: "";
          position: absolute;
          top: -50%;
          left: -50%;
          width: 200%;
          height: 200%;
          background:
          radial-gradient(circle at 30% 30%, rgba(245,194,231,0.15) 0%, transparent 60%),
          radial-gradient(circle at 70% 20%, rgba(137,180,250,0.1) 0%, transparent 50%),
          radial-gradient(circle at 40% 70%, rgba(80,250,123,0.08) 0%, transparent 60%),
          radial-gradient(circle at 60% 50%, rgba(245,224,220,0.05) 0%, transparent 70%);
          background-size: 200% 200%;
          filter: blur(140px);
          animation:
          moveNebula1 40s linear infinite,
          moveNebula2 60s linear infinite,
          rotateNebula 120s linear infinite;
          z-index: -1;
          }
          @keyframes moveNebula1 {
          0% { background-position: 0% 0%, 0% 0%, 0% 0%, 0% 0%; }
          50% { background-position: 15% 25%, 10% 20%, 5% 30%, 20% 10%; }
          100% { background-position: 0% 0%, 0% 0%, 0% 0%, 0% 0%; }
          }
          @keyframes moveNebula2 {
          0% { background-position: 0% 0%, 0% 0%, 0% 0%, 0% 0%; }
          50% { background-position: 30% 10%, 20% 25%, 10% 15%, 5% 20%; }
          100% { background-position: 0% 0%, 0% 0%, 0% 0%, 0% 0%; }
          }
          @keyframes rotateNebula {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
          }
          h1 {
          text-align: center;
          color: #dbabf0;
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
          color: #d093ec;
          margin-left: 0.5rem;
          transition: text-shadow 0.3s, color 0.3s, transform 0.3s;
          text-shadow: 0 0 1px #4f5b75;
          }
          li a:hover {
          text-shadow: 0 0 3px #e0c4ec;
          color: #dbabf0;
          transform: translateX(8px) scale(1.05);
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
          /* Demo content styling */
          .content {
          position: relative;
          z-index: 10;
          padding: 40px;
          color: #cdd6f4; /* Catppuccin text */
          text-align: center;
          }
        </style>
      </head>
      <body>
        <!-- Demo content to show the background works with page content -->
        <div class="content">
          <h1>nebula quick access</h1>
          <h2>available services:</h2>
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
        </div>
        <!-- Three.js from CDN -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
        <script>
          // =============================================================================
          // CONFIGURATION - Easy to modify for developers
          // =============================================================================
          
          const MULTI_LAYER_CONFIG = {
              // Global animation settings
              animation: {
                  baseSpeed: 0.2,
                  frameRate: 0.016 // ~60fps
              },
              
              // Global scale for noise detail
              baseScale: 2.2,
              
              // Color palette (RGB values 0-1)
              colors: {
                  pink: [0.96, 0.54, 0.66],
                  blue: [0.54, 0.71, 0.98],
                  teal: [0.58, 0.89, 0.84],
                  purple: [0.80, 0.65, 0.97],
                  peach: [0.98, 0.70, 0.53],
                  lavender: [0.71, 0.75, 0.99],
                  sapphire: [0.45, 0.78, 0.93],
                  mauve: [0.74, 0.58, 0.98],
                  sky: [0.54, 0.86, 0.92],
                  rosewater: [0.96, 0.88, 0.86]
              },
              
              // Global visual effects
              effects: {
                  vignette: {
                      enabled: true,
                      strength: 0.6,
                      smoothness: 0.8
                  },
                  globalBlur: 10,
                  brightness: 0.5,
                  contrast: 1.5,
                  saturate: 2.5,
                  opacity: 0.7,
              },
              
              // Complex noise layers - EACH LAYER = ONE COLOR + MULTIPLE NOISE FUNCTIONS
              complexLayers: [
                  {
                      id: 'pink',
                      color: 'pink',
                      baseOpacity: 0.8,
                      blendMode: 'color-dodge',
                      simpleLayers: [
                          {
                              noiseType: 'fbm',
                              scale: 0.8,
                              weight: 0.7,
                              animation: { speed: [1.3, 1.2], amplitude: 0.5 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          },
                          {
                              noiseType: 'noise',
                              scale: 1.5,
                              weight: 0.6,
                              animation: { speed: [1.3, 1.4], amplitude: 0.3 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          }
                      ]
                  },
                  {
                      id: 'blue',
                      color: 'blue',
                      baseOpacity: 0.6,
                      blendMode: 'screen',
                      simpleLayers: [
                          {
                              noiseType: 'fbm',
                              scale: 1.2,
                              weight: 0.6,
                              animation: { speed: [0.7, 0.4], amplitude: 0.8 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                              distortion: true
                          },
                          {
                              noiseType: 'voronoi',
                              scale: 2.0,
                              weight: 0.4,
                              animation: { speed: [0.2, 0.6], amplitude: 0.4 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          }
                      ]
                  },
                  {
                      id: 'teal',
                      color: 'teal',
                      baseOpacity: 0.3,
                      blendMode: 'normal',
                      simpleLayers: [
                          {
                              noiseType: 'voronoi',
                              scale: 3.0,
                              weight: 0.8,
                              animation: { speed: [0.5, 0.8], amplitude: 0.2 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
          
                          },
                          {
                              noiseType: 'fbm',
                              scale: 4.0,
                              weight: 0.2,
                              animation: { speed: [1.0, 0.4], amplitude: 0.1 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
          
                          }
                      ]
                  },
                  {
                      id: 'purple',
                      color: 'purple',
                      baseOpacity: 0.8,
                      blendMode: 'normal',
                      simpleLayers: [
                          {
                              noiseType: 'fbm',
                              scale: 2.0,
                              weight: 1.0,
                              animation: { speed: [0.6, 0.4], amplitude: 1.2 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                              distortion: true
                          }
                      ]
                  },
                  {
                      id: 'sky',
                      color: 'sky',
                      baseOpacity: 0.05,
                      blendMode: 'color-dodge',
                      simpleLayers: [
                          {
                              noiseType: 'noise',
                              scale: 2.5,
                              weight: 0.7,
                              animation: { speed: [0.4, 1.1], amplitude: 0.6 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          },
                          {
                              noiseType: 'voronoi',
                              scale: 1.5,
                              weight: 0.3,
                              animation: { speed: [0.8, 0.2], amplitude: 0.8 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          }
                      ]
                  },
                  {
                      id: 'rosewater',
                      color: 'rosewater',
                      baseOpacity: 0.03,
                      blendMode: 'color-dodge',
                      simpleLayers: [
                          {
                              noiseType: 'noise',
                              scale: 1.5,
                              weight: 0.7,
                              animation: { speed: [0.5, -0.6], amplitude: 0.6 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          },
                          {
                              noiseType: 'voronoi',
                              scale: 2.0,
                              weight: 0.3,
                              animation: { speed: [-0.4, 0.5], amplitude: 0.8 },
                              offset: { x: Math.random() * 100 - 50, y: Math.random() * 100 - 50},
                          }
                      ]
                  }
              ]
          };
          
          // =============================================================================
          // MULTI-LAYER BACKGROUND SYSTEM
          // =============================================================================
          
          class MultiLayerNoiseBackground {
              constructor(config) {
                  this.config = config;
                  this.time = 0;
                  this.init();
              }
              
              init() {
                  this.setupScene();
                  this.createShader();
                  this.startAnimation();
                  this.setupResizeHandler();
              }
              
              setupScene() {
                  this.scene = new THREE.Scene();
                  this.camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
                  this.renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
                  
                  this.configureRenderer();
                  this.createGeometry();
              }
              
              configureRenderer() {
                  const { renderer } = this;
                  renderer.setSize(window.innerWidth, window.innerHeight);
                  renderer.setClearColor(0x000000, 0);
                  
                  const canvas = renderer.domElement;
                  canvas.style.position = 'fixed';
                  canvas.style.top = '0';
                  canvas.style.left = '0';
                  canvas.style.width = '100%';
                  canvas.style.height = '100%';
                  canvas.style.zIndex = '-1';
                  canvas.style.pointerEvents = 'none';
                  canvas.style.filter = `blur(''${this.config.effects.globalBlur}px) brightness(''${this.config.effects.brightness}) contrast(''${this.config.effects.contrast}) saturate(''${this.config.effects.saturate}) opacity(''${this.config.effects.opacity})`;
                  
                  document.body.appendChild(canvas);
              }
              
              createGeometry() {
                  this.geometry = new THREE.PlaneGeometry(2, 2);
              }
              
              createShader() {
                  const vertexShader = this.generateVertexShader();
                  const fragmentShader = this.generateFragmentShader();
                  
                  this.material = new THREE.ShaderMaterial({
                      uniforms: {
                          time: { value: 0.0 },
                          resolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) }
                      },
                      vertexShader,
                      fragmentShader,
                      transparent: true,
                      blending: THREE.NormalBlending,
                      depthWrite: false
                  });
                  
                  this.mesh = new THREE.Mesh(this.geometry, this.material);
                  this.scene.add(this.mesh);
              }
              
              generateVertexShader() {
                  return `
                      varying vec2 vUv;
                      
                      void main() {
                          vUv = uv;
                          gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
                      }
                  `;
              }
              
              generateFragmentShader() {
                  const { colors, complexLayers, effects, baseScale, animation } = this.config;
                  
                  return `
                      uniform float time;
                      uniform vec2 resolution;
                      varying vec2 vUv;
                      
                      ''${this.generateColorDefinitions(colors)}
                      ''${this.generateNoiseFunctions()}
                      ''${this.generateBlendingFunctions()}
                      
                      void main() {
                          vec2 uv = vUv;
                          float aspectRatio = resolution.x / resolution.y;
          
                          // Center the coordinates and keep them centered
                          vec2 centeredUv = uv - 0.5;
          
                          // Scale to maintain aspect ratio from center (keep centered)
                          vec2 worldUv;
                          worldUv = vec2(centeredUv.x, centeredUv.y / aspectRatio);
          
                          // Apply pixel scaling while keeping centered
                          float pixelScale = resolution.x / 800.0;
                          vec2 p = worldUv * ''${baseScale.toFixed(1)} * pixelScale;
                          float t = time * ''${animation.baseSpeed.toFixed(1)};
                          
                          // Initialize final color
                          vec3 finalColor = vec3(0.0);
                          float totalAlpha = 0.0;
                          
                          ''${this.generateComplexLayerCalculations(complexLayers)}
                          ''${this.generateLayerBlending()}
                          ''${this.generateEffects(effects)}
                          
                          gl_FragColor = vec4(finalColor, totalAlpha);
                      }
                  `;
              }
              
              generateColorDefinitions(colors) {
                  return Object.entries(colors)
                      .map(([name, rgb]) => `vec3 ''${name} = vec3(''${rgb.map(v => v.toFixed(3)).join(', ')});`)
                      .join('\n                    ');
              }
              
              generateNoiseFunctions() {
                  return `
                      // Hash function for pseudo-random numbers
                      float hash(vec2 p) {
                          return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
                      }
                      
                      // Smooth noise function
                      float noise(vec2 p) {
                          vec2 i = floor(p);
                          vec2 f = fract(p);
                          
                          float a = hash(i);
                          float b = hash(i + vec2(1.0, 0.0));
                          float c = hash(i + vec2(0.0, 1.0));
                          float d = hash(i + vec2(1.0, 1.0));
                          
                          vec2 u = f * f * (3.0 - 2.0 * f);
                          
                          return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
                      }
                      
                      // Fractal noise with multiple octaves
                      float fbm(vec2 p) {
                          float value = 0.0;
                          float amplitude = 0.5;
                          float frequency = 1.0;
                          
                          for (int i = 0; i < 6; i++) {
                              value += amplitude * noise(p * frequency);
                              amplitude *= 0.5;
                              frequency *= 2.0;
                          }
                          
                          return value;
                      }
                      
                      // Voronoi-like cellular noise
                      float voronoi(vec2 p) {
                          vec2 i = floor(p);
                          vec2 f = fract(p);
                          
                          float minDist = 1.0;
                          
                          for (int y = -1; y <= 1; y++) {
                              for (int x = -1; x <= 1; x++) {
                                  vec2 neighbor = vec2(float(x), float(y));
                                  vec2 point = hash(i + neighbor) * vec2(1.0, 1.0) + neighbor;
                                  float dist = length(point - f);
                                  minDist = min(minDist, dist);
                              }
                          }
                          
                          return minDist;
                      }
                  `;
              }
              
              generateBlendingFunctions() {
                  return `
                      // Blending functions for different blend modes
                      vec3 blendNormal(vec3 base, vec3 blend, float alpha) {
                          return mix(base, blend, alpha);
                      }
                      
                      vec3 blendScreen(vec3 base, vec3 blend, float alpha) {
                          vec3 result = 1.0 - (1.0 - base) * (1.0 - blend);
                          return mix(base, result, alpha);
                      }
                      
                      vec3 blendOverlay(vec3 base, vec3 blend, float alpha) {
                          vec3 result = mix(
                              2.0 * base * blend,
                              1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
                              step(0.5, base)
                          );
                          return mix(base, result, alpha);
                      }
                      
                      vec3 blendSoftLight(vec3 base, vec3 blend, float alpha) {
                          vec3 result = mix(
                              2.0 * base * blend + base * base * (1.0 - 2.0 * blend),
                              sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend),
                              step(0.5, blend)
                          );
                          return mix(base, result, alpha);
                      }
                      
                      vec3 blendColorDodge(vec3 base, vec3 blend, float alpha) {
                          vec3 result = base / (1.0 - blend + 0.001);
                          return mix(base, result, alpha);
                      }
                  `;
              }
              
              generateComplexLayerCalculations(complexLayers) {
                  let code = "";
                  
                  complexLayers.forEach((complexLayer, complexIndex) => {
                      code += `\n                        // Complex Layer ''${complexIndex + 1}: ''${complexLayer.id}\n                        `;
                      code += `float layer''${complexIndex}_combined = 0.0;\n                        `;
                      
                      // Generate simple layers within this complex layer
                      complexLayer.simpleLayers.forEach((simpleLayer, simpleIndex) => {
                          const { noiseType, scale, weight, animation, distortion } = simpleLayer;
                          const offsetVar = `offset_''${complexIndex}_''${simpleIndex}`;
                          const noiseVar = `noise_''${complexIndex}_''${simpleIndex}`;
          
                          const randomOffset = `vec2(''${simpleLayer.offset.x.toFixed(2)}, ''${simpleLayer.offset.y.toFixed(2)})`;
          
                          
                          // Generate animation offset
                          code += `vec2 ''${offsetVar} = vec2(cos(t * ''${animation.speed[0].toFixed(1)}), sin(t * ''${animation.speed[1].toFixed(1)})) * ''${animation.amplitude.toFixed(1)} + ''${randomOffset};\n`;
                          
                          // Generate noise calculation
                          if (distortion) {
                              code += `vec2 distortion_''${complexIndex}_''${simpleIndex} = vec2(sin(p.x * 2.0 + time * 0.3) * 0.1, cos(p.y * 2.0 + time * 0.2) * 0.1);\n                        `;
                              code += `float ''${noiseVar} = ''${noiseType}(p * ''${scale.toFixed(1)} + ''${offsetVar} + distortion_''${complexIndex}_''${simpleIndex});\n                        `;
                          } else {
                              code += `float ''${noiseVar} = ''${noiseType}(p * ''${scale.toFixed(1)} + ''${offsetVar});\n                        `;
                          }
                          
                          // Add to combined noise for this complex layer
                          code += `layer''${complexIndex}_combined += ''${noiseVar} * ''${weight.toFixed(2)};\n                        `;
                      });
                      
                      // Normalize and create layer variables
                      code += `layer''${complexIndex}_combined = clamp(layer''${complexIndex}_combined, 0.0, 1.0);\n                        `;
                      code += `float layer''${complexIndex}_alpha = pow(layer''${complexIndex}_combined, 2.0) * ''${complexLayer.baseOpacity.toFixed(2)};\n                        `;
                      code += `vec3 layer''${complexIndex}_color = ''${complexLayer.color};\n                        `;
                  });
                  
                  return code;
              }
              
              generateLayerBlending() {
                  const { complexLayers } = this.config;
                  
                  let code = `
                          // Blend all complex layers together
                  `;
                  
                  complexLayers.forEach((complexLayer, index) => {
                      if (index === 0) {
                          code += `finalColor = layer''${index}_color * layer''${index}_alpha;\n                        `;
                          code += `totalAlpha = layer''${index}_alpha;\n                        `;
                      } else {
                          const blendMode = complexLayer.blendMode || 'normal';
                          
                          switch (blendMode) {
                              case 'screen':
                                  code += `finalColor = blendScreen(finalColor, layer''${index}_color, layer''${index}_alpha);\n                        `;
                                  break;
                              case 'overlay':
                                  code += `finalColor = blendOverlay(finalColor, layer''${index}_color, layer''${index}_alpha);\n                        `;
                                  break;
                              case 'soft-light':
                                  code += `finalColor = blendSoftLight(finalColor, layer''${index}_color, layer''${index}_alpha);\n                        `;
                                  break;
                              case 'color-dodge':
                                  code += `finalColor = blendColorDodge(finalColor, layer''${index}_color, layer''${index}_alpha);\n                        `;
                                  break;
                              default: // normal
                                  code += `finalColor = blendNormal(finalColor, layer''${index}_color, layer''${index}_alpha);\n                        `;
                          }
                          
                          code += `totalAlpha = min(1.0, totalAlpha + layer''${index}_alpha * 0.5);\n                        `;
                      }
                  });
                  
                  return code;
              }
              
              generateEffects(effects) {
                  let code = "";
                  
                  if (effects.vignette?.enabled) {
                      code += `
                          // Vignette effect
                          float vignette = 1.0 - length(uv - 0.5) * ''${effects.vignette.strength.toFixed(1)};
                          vignette = smoothstep(0.0, 1.0, vignette);
                          totalAlpha *= vignette;
                          finalColor *= (0.8 + 0.2 * vignette);
                      `;
                  }
                  
                  // Ensure alpha is in valid range
                  code += `
                          totalAlpha = clamp(totalAlpha, 0.0, 0.9);
                  `;
                  
                  return code;
              }
              
              startAnimation() {
                  const animate = () => {
                      requestAnimationFrame(animate);
                      
                      this.time += this.config.animation.frameRate;
                      this.material.uniforms.time.value = this.time;
                      
                      this.renderer.render(this.scene, this.camera);
                  };
                  
                  animate();
              }
              
              setupResizeHandler() {
                  const onResize = () => {
                      this.renderer.setSize(window.innerWidth, window.innerHeight);
                      this.material.uniforms.resolution.value.set(window.innerWidth, window.innerHeight);
                  };
                  
                  window.addEventListener('resize', onResize);
              }
          }
          
          // =============================================================================
          // INITIALIZATION
          // =============================================================================
          
          function initializeBackground() {
              new MultiLayerNoiseBackground(MULTI_LAYER_CONFIG);
          }
          
          // Initialize when DOM is ready
          if (document.readyState === 'loading') {
              document.addEventListener('DOMContentLoaded', initializeBackground);
          } else {
              initializeBackground();
          }
        </script>
      </body>
    </html>
  '';
}
