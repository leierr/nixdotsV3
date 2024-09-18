{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.rofi;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.rofi = {
    enable = lib.mkEnableOption "";
    plugins.rbw.enable = lib.mkEnableOption "";
    drun_exec = lib.mkOption { type = lib.types.str; default = "rofi -show drun -config ~/.config/rofi/drun.rasi"; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) (lib.mkMerge [
    ({
      environment.systemPackages = with pkgs; [
      # dependencies to run correctly
      rofi-wayland
      hack-font
      nerdfonts
      papirus-icon-theme
    ]})

    (import ./configs/theme { inherit theme; })
    (import ./configs/drun)
    (lib.mkIf cfg.plugins.rbw.enable (import ./configs/rbw { inherit pkgs; }))
  ])
}
