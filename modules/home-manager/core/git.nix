{
  miniluz-pkgs,
  pkgs,
  config,
  lib,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      userName = "miniluz";
      userEmail = "javiermelon4fu@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      delta.enable = true;
    };

    jujutsu = {
      enable = true;

      settings = {
        ui = {
          default-command = [ "log" ];
          paginate = "never";
        };

        user = {
          name = "miniluz";
          email = "javiermelon4fu@gmail.con";
        };
      };

    };
  };

  home.packages = lib.concatLists [
    [
      miniluz-pkgs.git-clean-branches
      pkgs.lazyjj

    ]
    (if config.miniluz.visual then [ pkgs.gg-jj ] else [ ])
  ];
}
