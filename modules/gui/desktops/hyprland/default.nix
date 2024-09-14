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
          package = inputs.hyprland.packages."${pkgs.system}".hyprland;
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

              "$mod, 1, split:workspace, 1"
              "$mod, 2, split:workspace, 2"
              "$mod, 3, split:workspace, 3"
              "$mod, 4, split:workspace, 4"
              "$mod, 5, split:workspace, 5"

              "$mod SHIFT, 1, split:movetoworkspacesilent, 1"
              "$mod SHIFT, 2, split:movetoworkspacesilent, 2"
              "$mod SHIFT, 3, split:movetoworkspacesilent, 3"
              "$mod SHIFT, 4, split:movetoworkspacesilent, 4"
              "$mod SHIFT, 5, split:movetoworkspacesilent, 5"
						];

            # mouse binds
            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];

            plugin = {
              hyprsplit = {
                num_workspaces = 6;
              };
            };
					};

					plugins = [
            inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
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
