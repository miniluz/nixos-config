# Configuration common to all computers
{
  inputs,
  pkgs,
  miniluz-pkgs,
  lib,
  global-secrets,
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

    boot.kernel.sysctl."kernel.sysrq" = mkDefault 1;

    nix.optimise.automatic = mkDefault true;

    # Set timezone
    time.timeZone = mkDefault "Europe/Madrid";

    console.keyMap = mkDefault "es";

    # Set keyboard layout for console and xserver
    services = {
      xserver.xkb = mkDefault {
        layout = "es";
        variant = "";
      };

      earlyoom.enable = mkDefault true;

      openssh = {
        enable = mkDefault true;
        settings.PasswordAuthentication = mkDefault false;
      };

      fail2ban.enable = mkDefault true;
    };

    i18n.inputMethod = {
      enable = mkDefault true;
      type = "fcitx5";
      fcitx5 = {
        addons = mkDefault (with pkgs; [ fcitx5-gtk ]);
        waylandFrontend = mkDefault false;
        ignoreUserConfig = mkDefault true;
        settings = {
          inputMethod = mkDefault {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "es";
              DefaultIM = "keyboard-es";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-es";
              Layout = "";
            };
          };
          globalOptions = mkDefault {
            Hotkey = {
              TriggerKeys = "";
              EnumerateWithTriggerKeys = "False";
              ActivateKeys = "";
              DeactivateKeys = "";
              AltTriggerKeys = "";
              EnumerateForwardKeys = "";
              EnumerateBackwardKeys = "";
              EnumerateSkipFirst = "False";
              EnumerateGroupForwardKeys = "";
              EnumerateGroupBackwardKeys = "";
              PrevPage = "";
              NextPage = "";
              PrevCandidate = "";
              NextCandidate = "";
              TogglePreedit = "";
              ModifierOnlyKeyTimeout = "250";
            };
            Behavior = {
              ActiveByDefault = "False";
              resetStateWhenFocusIn = "No";
              ShareInputState = "No";
              PreeditEnabledByDefault = "True";
              ShowInputMethodInformation = "True";
              showInputMethodInformationWhenFocusIn = "False";
              CompactInputMethodInformation = "True";
              ShowFirstInputMethodInformation = "True";
              DefaultPageSize = "5";
              OverrideXkbOption = "False";
              CustomXkbOption = "";
              EnabledAddons = "";
              DisabledAddons = "";
              PreloadInputMethod = "True";
              AllowInputMethodForPassword = "False";
              ShowPreeditForPassword = "False";
              AutoSavePeriod = "30";
            };
          };
        };
      };
    };

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

    hj.files.".bashrc".text = mkDefault ''
      if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${lib.getExe miniluz-pkgs.luz-shell} $LOGIN_OPTION
      fi
    '';

    hj.files.".bash_profile".text = mkDefault ''
      if [ -f ~/.bashrc ]; then
        . ~/.bashrc
      fi
      if [ -f ~/.profile ]; then
        . ~/.profile
      fi
    '';

    networking.networkmanager.enable = mkDefault true;

    environment.localBinInPath = mkDefault true;

    environment.systemPackages =
      with pkgs;
      [
        steam-run
        nixfmt
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
        enable = mkDefault true;
        clean = {
          enable = mkDefault true;
          extraArgs = mkDefault "--keep 5 --keep-since 7d --no-gcroots";
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
