# Configuration common to all computers
{
  inputs,
  pkgs,
  miniluz-pkgs,
  lib,
  global-secrets,
  config,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.miniluz.visual = lib.mkOption {
    default = true;
    description = "Enable options for visual systems";
  };

  config = {
    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

    zramSwap.enable = mkDefault true;

    nix.optimise.automatic = mkDefault true;

    # Set timezone
    time.timeZone = mkDefault "Europe/Madrid";

    # Set keyboard layout for console and xserver
    services.xserver.xkb = mkDefault {
      layout = "es";
      variant = "";
    };
    console.keyMap = mkDefault "es";

    # My user
    users = {
      users.miniluz = {
        uid = 1000;
        isNormalUser = true;
        description = "miniluz";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "plugdev"
          "dialout"
        ];
        openssh.authorizedKeys.keyFiles = [ "${global-secrets}/miniluz.pub" ];
      };

      groups = {
        users.gid = 100;
        plugdev = { };
      };
    };

    hj.files.".bashrc".text = ''
      if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${lib.getExe miniluz-pkgs.luz-shell} $LOGIN_OPTION
      fi
    '';

    services = {
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };
      fail2ban.enable = true;
    };

    networking.networkmanager.enable = mkDefault true;

    environment.systemPackages =
      with pkgs;
      [
        steam-run
        nixfmt-rfc-style
        nil
        nushell
        inputs.agenix.packages.x86_64-linux.default
      ]
      ++ (with miniluz-pkgs; [
        luz-shell-utils
        luz-shell

        font-cache-update
        luznix-rebuild
        luznix-os-switch
        luznix-update-command
      ]);

    environment.sessionVariables = {
      EDITOR = "nvim";
      NH_FLAKE = "/home/miniluz/nixos-config";
    };

    programs = {
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 7d";
        };
      };
      command-not-found.enable = mkDefault false;
      ssh.startAgent = mkDefault true;
      nix-ld.enable = mkDefault true;
      nix-index-database.comma.enable = mkDefault true;
    };

    documentation.man.generateCaches = false;
    documentation.nixos.enable = false;

  };
}
