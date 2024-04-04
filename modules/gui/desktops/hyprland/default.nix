{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui.desktops.hyprland;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.desktops.hyprland = {
    enable = lib.mkEnableOption "";
    hyprpaper.enable = lib.mkOption { type = lib.types.bool; default = true; };
    hypridle.enable = lib.mkOption { type = lib.types.bool; default = true; };
    hyprlock.enable = lib.mkOption { type = lib.types.bool; default = true; };
    hyprlock.profile_pic = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
    ags.enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  # https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/99#issuecomment-1731390092

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = pkgs.unstable.hyprland;
      xwayland.enable = true;
      enableNvidiaPatches = false;
    };

    security.pam.services.hyprlock = lib.mkIf cfg.hyprlock.enable {};

    home_manager_modules = [
      inputs.hyprland.homeManagerModules.default
      inputs.hyprpaper.homeManagerModules.default
      inputs.ags.homeManagerModules.default
      inputs.hypridle.homeManagerModules.default
      inputs.hyprlock.homeManagerModules.default

      (lib.mkIf cfg.hyprpaper.enable (import ./hyprpaper))
      (lib.mkIf cfg.hyprlock.enable (import ./hyprlock { inherit cfg theme inputs; }))
    ];
  };
}
