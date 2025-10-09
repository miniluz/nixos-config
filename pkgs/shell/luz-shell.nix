{
  lib,
  symlinkJoin,
  makeWrapper,
  writeTextDir,
  pkgs,
  fish,
  starship-luzwrap,
  luz-shell-utils,
  usedFishPluginNames ? [
    "fzf-fish"
    "autopair"
    "puffer"
  ],
  usedFishPlugins ? builtins.map (name: {
    inherit name;
    "src" = pkgs.fishPlugins.${name}.src;
  }) usedFishPluginNames,
}:
let
  fish-utils = import ./_fish-utils.nix { inherit writeTextDir; };
  fishPluginFiles = builtins.map (
    plugin: fish-utils.makePluginFile "1-${plugin.name}" (fish-utils.pluginTextFromPlugins plugin)
  ) usedFishPlugins;
in
symlinkJoin {
  name = "luz-shell";
  paths = [
    fish
    starship-luzwrap
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/fish \
      --prefix XDG_DATA_DIRS : ${
        symlinkJoin {
          name = "fish-config";
          paths = fishPluginFiles ++ [
            (fish-utils.makePluginFile "99-config" (builtins.readFile ./fish-config.fish))
          ];
        }
      } \
      --prefix PATH : ${lib.makeBinPath [ luz-shell-utils ]}
  '';
}
