{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui.desktops.hyprland;
in
{
  options.system_settings.gui.desktops.hyprland = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    home_manager_modules = [
      ({
        wayland.windowManager.hyprland = {
          enable = true;
					settings = {
            # variables
						"$mod" = "SUPER";
						"$terminal" = "alacritty";
            "$browser" = "firefox --new-window";
						"$application_launcher" = "rofi -show drun";

            # autostart
						exec-once = [
              "$browser"
              "discord"
            ];

            exec = [
              "pgrep kanshi || kanshi &" "pgrep kanshi && kanshictl reload"
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
					plugins = [
            #inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
          ];
        };
      })
    ];

    # dependencies
    environment.systemPackages = with pkgs; [
      rofi-wayland
      kanshi
    ];
  };
}
