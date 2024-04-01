{ config, lib, pkgs, inputs ... }:

let
  cfg = config.system_settings.gui.desktops.hyprland;
in
{
  options.system_settings.gui.desktops.hyprland = {
    enable = lib.mkEnableOption "";
    hyprpaper.enable = lib.mkOption { type = lib.types.bool; default = true; };
    hypridle.enable = lib.mkOption { type = lib.types.bool; default = true; };
    hyprlock.enable = lib.mkOption { type = lib.types.bool; default = true; };
    ags.enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  # https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/99#issuecomment-1731390092

  config = lib.mkif cfg.enable {
    programs.hyprland = {
      package = pkgs.hyprland;
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = false;
    };

    home_manager_modules = [
      inputs.hyprland.homeManagerModules.default

      #(lib.mkIf cfg.hyprpaper.enable inputs.hyprpaper.homeManagerModules.default)
      #(lib.mkIf cfg.ags.enable inputs.ags.homeManagerModules.default)
      #(lib.mkIf cfg.hypridle.enable inputs.hypridle.homeManagerModules.default)
      #(lib.mkIf cfg.hyprlock.enable inputs.hyprlock.homeManagerModules.default)

      (import ./modules/hyprpaper.nix)
    ];
  };
}
