{
  pkgs,
  miniluz-pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.miniluz.shell;
in
{
  config = lib.mkIf cfg.enable {

    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${miniluz-pkgs.luz-shell}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

  };
}
