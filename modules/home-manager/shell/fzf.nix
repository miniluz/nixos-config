{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.fzf;
in
{
  options.miniluz.fzf.enable = lib.mkEnableOption "Enable FZF.";

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    } // (if config.miniluz.zsh.enable then { enableZshIntegration = true; } else { });

    programs.zsh =
      if config.miniluz.zsh.enable then {
        plugins = with pkgs; [
          {
            name = "fzf-tab";
            file = "fzf-tab.plugin.zsh";
            src = "${zsh-fzf-tab}/share/fzf-tab";
          }
        ];

        # Source: https://github.com/catppuccin/fzf, https://vitormv.github.io/fzf-themes/
        envExtra = ''zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --oneline --icons --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --oneline --icons --color=always $realpath'
export FZF_DEFAULT_OPTS='
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --multi
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
'';
      }
      else { };
  };
}
