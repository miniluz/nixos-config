# ~/.config/fish/config.fish: DO NOT EDIT -- this file has been generated
# automatically by home-manager.

# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

status is-login; and begin

    # Login shell initialisation

end

status is-interactive; and begin

    # eval (zellij setup --generate-auto-start fish | string collect)

    if not set -q TMUX
        tmux
    end

    starship init fish | source
    enable_transience
    
    # Aliases
    alias cd z
    alias exal 'eza --long --header --icons --git'
    alias la 'eza -a'
    alias ll 'eza -l'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'

    # Interactive shell initialisation
    fzf --fish | source

    set fish_greeting # Disable greeting

    function fish_command_not_found
        comma "$argv"
    end

    # Source: https://github.com/catppuccin/fzf, https://vitormv.github.io/fzf-themes/
    set FZF_DEFAULT_OPTS '
        --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
        --color=selected-bg:#45475a
        --multi
        --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
        --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

    zoxide init fish | source


    function __fish_command_not_found_handler --on-event fish_command_not_found
        command-not-found $argv
    end

    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION no-rc
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    # for yazi
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # stolen from llakala
    set FZF_DEFAULT_OPTS  "--with-shell='sh -c' --bind 'i:show-input+trigger(start),esc:hide-input+trigger(start)' --bind 'j:down,k:up,f:jump-accept' --bind 'start:toggle-bind(i,j,k,f)' --bind 'ctrl-l:accept'"
    set FZF_ALT_C_COMMAND zoxide query --list --score
    set FZF_ALT_C_OPTS --height 40% --layout reverse --border rounded --nth 2.. --accept-nth 2.. --scheme=path --exact --tiebreak="pathname,index"

    direnv hook fish | source

end
