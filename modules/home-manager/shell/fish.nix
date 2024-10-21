# Don't forget to add
# environment.pathsToLink = [ "/share/zsh" ];
# to the system configuration.
{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.fish;
  # Source: https://github.com/catppuccin/fzf, https://vitormv.github.io/fzf-themes/
  fzf-config = ''
    set FZF_DEFAULT_OPTS '
    --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --color=selected-bg:#45475a
    --multi
    --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
    --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
  '';
in
{
  options.miniluz.fish = {
    enable = lib.mkEnableOption "Enable miniluz's fish.";
  };

  config = lib.mkIf cfg.enable {


    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '' + fzf-config;

      plugins = [
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      ];
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

    # Get with tide configure
    home.activation.configure-tide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Few icons' --transient=Yes"
    '';

    programs.command-not-found.enable = true;

    programs.fzf.enable = true;
    programs.fd.enable = true;
    programs.bat.enable = true;

  };
}
