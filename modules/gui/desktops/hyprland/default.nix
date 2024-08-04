{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.desktops.hyprland;
in
{
  options.system_settings.gui.desktops.hyprland = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    programs.hyprland.enable = true;

    home_manager_modules = [
      ({
        wayland.windowManager.hyprland = {
          enable = true;
					settings = {};
					plugins = [];
					extraConfig = "";
        };
      })
    ];

    # dependencies
    environment.systemPackages = with pkgs; [
			wofi
    ];
  };
}
