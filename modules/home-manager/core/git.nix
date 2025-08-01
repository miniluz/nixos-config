{
  miniluz-pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "miniluz";
    userEmail = "javiermelon4fu@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    delta.enable = true;
  };

  home.packages = with miniluz-pkgs; [
    git-clean-branches
  ];
}
