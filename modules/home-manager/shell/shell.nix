{
  lib,
  ...
}:
{
  options.miniluz.shell = {
    enable = lib.mkOption {
      default = true;
      description = "Enable shell options";
    };
  };
}
