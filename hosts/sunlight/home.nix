{
  config,
  pkgs,
  inputs,
  ...
}:
let
  homeManagerModules = "${inputs.self}/modules/home-manager";
in
{
  imports = [
    "${homeManagerModules}/git.nix"
    "${homeManagerModules}/blender.nix"
    "${homeManagerModules}/firacode.nix"
    "${homeManagerModules}/firefox.nix"
    "${homeManagerModules}/libreoffice.nix"
    "${homeManagerModules}/obsidian.nix"

    # "${homeManagerModules}/vscode-server.nix"
    "${homeManagerModules}/vscode/vscode.nix"

    "${homeManagerModules}/helix/helix.nix"

    "${homeManagerModules}/discord.nix"

    "${homeManagerModules}/gnome/gnome.nix"

    "${homeManagerModules}/music/music.nix"

    "${homeManagerModules}/shell/utils/shell-utils.nix"
    "${homeManagerModules}/shell/gitui.nix"
    "${homeManagerModules}/shell/kitty.nix"
    "${homeManagerModules}/shell/fish.nix"
    /*
      TODO:
      * tdrop
    */
  ];

  miniluz.git.enable = true;

  miniluz.blender.enable = false;
  miniluz.firacode.enable = true;
  miniluz.firefox.enable = true;

  miniluz.libreoffice.enable = true;
  miniluz.obsidian.enable = true;

  miniluz.music.enable = true;

  miniluz.fish.enable = true;
  miniluz.shell-utils.enable = true;

  miniluz.gitui.enable = true;
  miniluz.kitty.enable = true;

  miniluz.vscode = {
    enable = true;
    catppuccin = true;
    firacode = true;
    java = true;
    js = true;
    rust = true;
    vim = true;
  };

  miniluz.helix.enable = true;

  miniluz.discord.enable = true;

  miniluz.gnome.enable = true;
  miniluz.gnome.catppuccin.enable = true;
  miniluz.gnome.background.enable = true;
  miniluz.gnome.background.path = "persona_3_blue_down.png";

  programs.firefox.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "miniluz";
  home.homeDirectory = "/home/miniluz";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.vlc
    pkgs.qbittorrent
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/miniluz/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
