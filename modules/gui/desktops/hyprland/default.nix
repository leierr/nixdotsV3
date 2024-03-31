{ config, lib, pkgs, inputs ... }:

let
  cfg = config.system_settings.gui;
in
{
  options.system_settings.gui.desktops.hyprland = {
    enable = lib.mkEnableOption "";
  };

  # https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/99#issuecomment-1731390092

  config = {
    programs.hyprland = {
      package = pkgs.hyprland;
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = false;
    };

    home_manager_modules = [
      inputs.ags.homeManagerModules.default
      inputs.hyprland.homeManagerModules.default
      inputs.hyprpaper.homeManagerModules.default
      inputs.hypridle.homeManagerModules.default
      inputs.hyprlock.homeManagerModules.default

      ({

      })
    ];
  };
}
