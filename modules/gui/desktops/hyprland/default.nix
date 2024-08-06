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
					settings = {
            # variables
						"$mod" = "SUPER";
						"$terminal" = "alacritty";
            "$browser" = "firefox --new-window";
						"$application_launcher" = "wofi --show drun";

            # autostart
						exec-once = [
              "$browser"
              "discord"
            ];

            # keyboard binds
						bind = [
							"$mod, Return, exec, $terminal"
							"$mod, W, killactive"
							"$mod, escape, exit"
							"$mod, D, exec, $application_launcher"
						];

            # mouse binds
            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];
					};
					plugins = [];
        };
      })
    ];

    # dependencies
    environment.systemPackages = with pkgs; [
			wofi
    ];
  };
}
