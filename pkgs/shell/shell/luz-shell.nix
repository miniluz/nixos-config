{
  lib,
  symlinkJoin,
  makeWrapper,
  writeTextDir,
  runCommand,
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
  fish-utils = import ./_fish-utils.nix { inherit writeTextDir runCommand; };
  fishPluginFiles = builtins.map (
    plugin:
    fish-utils.makePluginFileFromText "1-${plugin.name}" (fish-utils.pluginTextFromPlugins plugin)
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
            (fish-utils.makePluginFile "99-config" (builtins.toString ./fish-config.fish))
          ];
        }
      } \
      --prefix PATH : ${lib.makeBinPath [ luz-shell-utils ]}
  '';

  meta.mainProgram = "fish";

}
