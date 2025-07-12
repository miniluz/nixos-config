{ pkgs, ... }:
{
  config.vim = {
    languages.nix = {
      enable = true;
      lsp = {
        server = "nixd";
        options = {
          nixos = {
            expr = ''(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.moonlight.options'';
          };
          home_manager = {
            expr = ''(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.moonlight.options.home-manager.users.type.getSubOptions []'';
          };
        };
      };
      format.package = pkgs.nixfmt-rfc-style;
    };
  };
}
