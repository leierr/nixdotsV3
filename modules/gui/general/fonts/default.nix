{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.fonts;
in
{
  options.system_settings.gui.fonts = {
    enable = lib.mkEnableOption "";

    default_fonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        hack-font
        nerdfonts
      ];
      description = "default fonts I usually want to have available on every GUI system, can easily be overwritten or disabled";
    };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    fonts.enableDefaultPackages = true;
    fonts.packages = cfg.default_fonts;
  };
}
