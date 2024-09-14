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
    programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    programs.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    home_manager_modules = [
      ({
        wayland.windowManager.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          plugins = [
            inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
          ];
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

            general = {
              # borders
              border_size = 1;
              no_border_on_floating = false;
              #col.inactive_border
              #col.active_border

              # gaps
              gaps_in = 10;
              gaps_out = 20;

              # layout
              layout = "dwindle";
            };

            misc = {
              # disable default graphics
              disable_hyprland_logo = true;
              disable_splash_rendering = true;

            };

            dwindle = {
              # spawn new windows to the right
              force_split = 2;
            };

            # keyboard binds
            bind = [
              "$mod, Return, exec, $terminal"
              "$mod, D, exec, $application_launcher"

              # Window managment
              "$mod, W, killactive"

              # WM control center
              "$mod Control_L, R, exec, hyprctl reload config-only"
              "$mod Control_L&SHIFT, R, exec, hyprctl reload"

              "$mod Control_L, ESCAPE, exit"
              "$mod Control_L&SHIFT, ESCAPE, exec, systemctl poweroff"

              # moving about the WM
              "$mod, 1, split-workspace, 1"
              "$mod, 2, split-workspace, 2"
              "$mod, 3, split-workspace, 3"
              "$mod, 4, split-workspace, 4"
              "$mod, 5, split-workspace, 5"
              "$mod, 6, split-workspace, 6"

              "$mod SHIFT, 1, split-movetoworkspacesilent, 1"
              "$mod SHIFT, 2, split-movetoworkspacesilent, 2"
              "$mod SHIFT, 3, split-movetoworkspacesilent, 3"
              "$mod SHIFT, 4, split-movetoworkspacesilent, 4"
              "$mod SHIFT, 5, split-movetoworkspacesilent, 5"
              "$mod SHIFT, 6, split-movetoworkspacesilent, 6"

              "$mod, o, focusmonitor, +1"
              "$mod SHIFT, o, split-changemonitor, +1"

              "$mod, c, cyclenext"
              "$mod SHIFT, c, swapnext"
            ];

            # mouse binds
            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];

            plugin = {
              split-monitor-workspaces = {
                count = 6;
                keep_focused = 1;
                enable_persistent_workspaces = 1;
              };
            };
          };
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
