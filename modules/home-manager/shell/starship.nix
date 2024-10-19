{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.starship;
in
{
  options.miniluz.starship.enable = lib.mkEnableOption "Enable miniluz's zsh with Starship.";

  config = lib.mkIf cfg.enable {
    programs.starship.enable = true;
    programs.starship.settings = {
      format = "$directory$nix_shell$git_branch$git_status\n$character";
      # add_newline = false;
      directory = {
        style = "bold blue";
        read_only_style = "bold blue";
        fish_style_pwd_dir_length = 1;
        truncation_length = 5;
      };
      git_branch = {
        format = "[$branch](dimmed bold white) ";
      };
      git_status = {
        stashed = "";
        format = "[$ahead_behind](dimmed bold white) ";
      };
      nix_shell = {
        format = "[❄️](bold blue) ";
      };
      character = {
        format = "$symbol";
        success_symbol = "[](bold purple) ";
        error_symbol = "[](bold red) ";
      };
    };

    programs.zsh.oh-my-zsh =
      if config.miniluz.starship.enable then {
        enable = true;
        plugins = [ "starship" ];
      } else { };
  };
}
