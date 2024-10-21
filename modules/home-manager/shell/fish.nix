# Don't forget to add
# environment.pathsToLink = [ "/share/zsh" ];
# to the system configuration.
{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.fish;
in
{
  options.miniluz.fish = {
    enable = lib.mkEnableOption "Enable miniluz's fish.";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };

    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    programs.command-not-found.enable = true;
  };
}
