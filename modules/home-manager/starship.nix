{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.starship;
in
{
  options.miniluz.starship.enable = lib.mkEnableOption "Enable miniluz's zsh with Starship.";

  config = lib.mkIf cfg.enable {
    programs.starship.enable = true;
    programs.starship.settings = {
      format = "$character[$directory](cyan bold)$git_branch$git_status ";
      add_newline = false;
      username = {
        "format" = "$user";
        "show_always" = true;
      };
      directory = {
        format = "  $path";
        truncation_length = 1;
      };
      git_branch = {
        symbol = " ";
        format = " [$symbol git:\\(](blue bold)[$branch](red bold)[\\)](blue bold)";
      };
      git_status = {
        format = "[$all_status$ahead_behind](red bold)";
      };
      time = {
        disabled = false;
        time_format = "%R";
        format = "$time";
      };
      character = {
        format = "$symbol ";
        success_symbol = "[](red)[](bright-green)[](yellow)";
        error_symbol = "[](red)";
      };
    };
  };
}
