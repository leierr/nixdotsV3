{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui.desktops.hyprland;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.desktops.hyprland = {
    enable = lib.mkEnableOption "";
    hyprpaper.enable = lib.mkOption { type = lib.types.bool; default = true; };
    hyprlock.enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) (lib.mkMerge [
    (lib.mkIf cfg.hyprpaper.enable (import ./hyprpaper { inherit lib pkgs theme; }))
    (lib.mkIf cfg.hyprlock.enable (import ./hyprlock { inherit lib pkgs theme; }))

    {
      programs.hyprland.enable = true;
      programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      programs.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

      system_settings.gui.rofi.enable = true;
      system_settings.gui.rofi.plugins.rbw.enable = true;

      home_manager_modules = [
        ({
          wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
            plugins = [
              inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
            ];
            settings = {
              # variables
              "$mod" = "SUPER";
              "$terminal" = "alacritty";
              "$browser" = "firefox";
              "$application_launcher" = "${config.system_settings.gui.rofi.drun_exec}";
              "$screenshot_exec" = "grimblast --freeze copy area";

              env = [
                "QT_QPA_PLATFORM,wayland"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
                "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
                "MOZ_WEBRENDER,1"
                "SDL_VIDEODRIVER,wayland"
                "GDK_BACKEND,wayland"
              ];

              # autostart
              exec-once = [
                "$browser"
                "discord"
              ];

              exec = [
                "pgrep kanshi || kanshi &" "pgrep kanshi && kanshictl reload"
                "pgrep hyprpaper || hyprpaper &"
              ];

              general = {
                # borders
                border_size = 2;
                no_border_on_floating = false;
                "col.inactive_border" = "rgb(${builtins.replaceStrings ["#"] [""] theme.unfocused_border_color})";
                "col.active_border" = "rgb(${builtins.replaceStrings ["#"] [""] theme.focused_border_color})";

                # gaps
                gaps_in = 10;
                gaps_out = 20;

                # layout
                layout = "dwindle";
              };

              decoration = {
                rounding = 10;
                blur.enabled = false;

                # shadows
                drop_shadow = true;
                shadow_ignore_window = true;
                shadow_offset = "1 3";
                shadow_range = 25;
                shadow_render_power = 3;
                "col.shadow" = "rgba(000000BF)";
              };

              animations = {
                enabled = false;
              };

              misc = {
                # disable default shit
                disable_hyprland_logo = true;
                disable_splash_rendering = true;

              };

              dwindle = {
                # spawn new windows to the right
                force_split = 2;
              };

              # window rules
              windowrulev2 = [
                # only allow shadows for floating windows
                "noshadow, floating:0"

                # general
                "float, class:^(nm-connection-editor)$"
                "float, class:^(gnome-calculator|org\.gnome\.Calculator)$"
                "float, class:^(pavucontrol)$"
                "nomaxsize, class:^(firefox)$"

                # rofi
                "stayfocused,class:^(Rofi)$"
              ];

              # workspace rules
              workspace = [];

              # keyboard binds
              bind = [
                "$mod, Return, exec, $terminal"
                "$mod, D, exec, $application_launcher"
                "$mod, Q, exec, $screenshot_exec"
                "$mod, B, exec, ${config.system_settings.gui.rofi.plugins.rbw.exec}/bin/rofi-rbw"
                "$mod, P, exec, hyprlock"

                # Window managment
                "$mod, W, killactive"
                "$mod, S, togglefloating"
                "$mod, F, fullscreen"
                "$mod, M, fullscreen, 1"

                # WM control center
                "$mod, R, exec, hyprctl reload config-only"
                "$mod Control_L, R, exec, hyprctl reload"

                "$mod, ESCAPE, exit"
                "$mod Control_L, ESCAPE, exec, systemctl poweroff"

                # moving about the WM
                "$mod, 1, split:workspace, 1"
                "$mod, 2, split:workspace, 2"
                "$mod, 3, split:workspace, 3"
                "$mod, 4, split:workspace, 4"
                "$mod, 5, split:workspace, 5"
                "$mod, 6, split:workspace, 6"

                "$mod SHIFT, 1, split:movetoworkspacesilent, 1"
                "$mod SHIFT, 2, split:movetoworkspacesilent, 2"
                "$mod SHIFT, 3, split:movetoworkspacesilent, 3"
                "$mod SHIFT, 4, split:movetoworkspacesilent, 4"
                "$mod SHIFT, 5, split:movetoworkspacesilent, 5"
                "$mod SHIFT, 6, split:movetoworkspacesilent, 6"

                "$mod, mouse_up, split:swapactiveworkspaces, current -1"
                "$mod, mouse_down, split:swapactiveworkspaces, current +1"

                "$mod, o, focusmonitor, +1"
                "$mod SHIFT, o, movewindow, mon:+1"

                "$mod, c, cyclenext"
                "$mod SHIFT, c, swapnext"

                "$mod, h, movefocus, l"
                "$mod, l, movefocus, r"
                "$mod, k, movefocus, u"
                "$mod, j, movefocus, d"

                "$mod, h, movewindow, l"
                "$mod, l, movewindow, r"
                "$mod, k, movewindow, u"
                "$mod, j, movewindow, d"
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
          };
        })
      ];

      # dependencies
      environment.systemPackages = with pkgs; [
        kanshi
        grimblast
        wl-clipboard
      ];
    }
  ]);
}
