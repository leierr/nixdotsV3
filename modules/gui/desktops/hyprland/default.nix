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
    ags.enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf (cfg.enable) (lib.mkMerge [
    (lib.mkIf cfg.hyprpaper.enable (import ./hyprpaper { inherit lib pkgs theme; }))
    (lib.mkIf cfg.hyprlock.enable (import ./hyprlock { inherit lib pkgs theme; }))
    (lib.mkIf cfg.hyprlock.enable (import ./hypridle { inherit lib pkgs; }))
    (lib.mkIf cfg.ags.enable (import ./ags { inherit lib pkgs theme; }))
    (lib.mkIf cfg.ags.enable (import ./terminal { inherit theme; }))

    {
      programs.hyprland.enable = true;
      programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      programs.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

      system_settings.gui.rofi.enable = true;
      system_settings.gui.rofi.plugins.rbw.enable = true;

      xdg.portal.config.hyprland.default = "*";

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
              "$terminal" = config.system_settings.gui.terminal_emulator.wayland.exec;
              "$browser" = "firefox";
              "$application_launcher" = "${config.system_settings.gui.rofi.drun_exec}";
              "$screenshot_exec" = "grimblast --freeze copy area";
              "$lockscreen" = "hyprlock";

              env = [
                "QT_QPA_PLATFORM,wayland"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
                "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
                "MOZ_WEBRENDER,1"
                "SDL_VIDEODRIVER,wayland"
                "GDK_BACKEND,wayland"
                "ADW_DISABLE_PORTAL,1"
              ];

              # autostart
              exec-once = [
                "$browser"
                "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit"
              ];

              exec = [
                "pidof hyprpaper || hyprpaper"
                "pidof hypridle || hypridle"
                "pidof ags || ags"
                "pidof nm-applet || nm-applet"
                "pidof pinentry-gnome3 || ${config.system_settings.gui.pinentry.package}/bin/pinentry-gnome3"
              ];

              general = {
                # borders
                border_size = 2;
                no_border_on_floating = false;
                "col.inactive_border" = "rgb(${builtins.replaceStrings ["#"] [""] theme.unfocused_border_color})";
                "col.active_border" = "rgb(${builtins.replaceStrings ["#"] [""] theme.green}) rgb(${builtins.replaceStrings ["#"] [""] theme.green}) rgb(${builtins.replaceStrings ["#"] [""] theme.green}) rgb(${builtins.replaceStrings ["#"] [""] theme.blue}) rgb(${builtins.replaceStrings ["#"] [""] theme.blue}) rgb(${builtins.replaceStrings ["#"] [""] theme.blue}) 30deg";

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
                shadow_offset = "0 0";
                shadow_range = 40;
                shadow_render_power = 6;
                "col.shadow" = "rgba(0, 0, 0, 0.9)";
              };

              animations = {
                enabled = false;
              };

              misc = {
                # disable default shit
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                focus_on_activate = true;
              };

              dwindle = {
                # spawn new windows to the right
                force_split = 2;
              };

              # window rules
              windowrulev2 = [
                # no decorations unless floating on single tile workspace
                "noborder, onworkspace:w[t1], floating:0"
                "rounding 0, onworkspace:w[t1], floating:0"
                "noshadow, onworkspace:w[t1], floating:0"

                # general
                "float, class:^(gnome-calculator|org\.gnome\.Calculator)$"
                "suppressevent maximize, class:^(.*)$"
              
                # pinentry
                "float, initialClass:^(gcr-prompter|nm-openconnect-auth-dialog|io.elementary.desktop.agent-polkit)$"
                "stayfocused, initialClass:^(gcr-prompter|nm-openconnect-auth-dialog|io.elementary.desktop.agent-polkit)$"
                "pin, initialClass:^(gcr-prompter|nm-openconnect-auth-dialog|io.elementary.desktop.agent-polkit)$"

                # rofi
                "stayfocused, class:^(Rofi)$"

                # temporary floaties
                "tag +tempfloat, initialTitle:^(Open File)$"
                "tag +tempfloat, class:^(nm-connection-editor|pavucontrol)$"
                "float, tag:tempfloat"
                "size 45% 45%, tag:tempfloat"
              ];

              # workspace rules
              workspace = [
                "w[t1], gapsout:0" 
              ];

              layerrule = [
                "dimaround, rofi"
              ];

              # keyboard binds
              bind = [
                "$mod, Return, exec, $terminal"
                "$mod, D, exec, $application_launcher"
                "$mod, Q, exec, $screenshot_exec"
                "$mod, B, exec, ${config.system_settings.gui.rofi.plugins.rbw.exec}/bin/rofi-rbw"

                # Window managment
                "$mod, W, killactive"
                "$mod, S, togglefloating"
                "$mod, F, fullscreen"
                "$mod, M, fullscreen, 1"

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

                "$mod, TAB, focusmonitor, +1"
                "$mod SHIFT, TAB, movewindow, mon:+1"

                "$mod, C, cyclenext"
                "$mod SHIFT, C, swapnext"

                "$mod, h, movefocus, l"
                "$mod, l, movefocus, r"
                "$mod, k, movefocus, u"
                "$mod, j, movefocus, d"

                "$mod SHIFT, h, movewindow, l"
                "$mod SHIFT, l, movewindow, r"
                "$mod SHIFT, k, movewindow, u"
                "$mod SHIFT, j, movewindow, d"
              ];

              # mouse binds
              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
              ];

              plugin = {
                hyprsplit = {
                  num_workspaces = 5;
                  persistent_workspaces = true;
                };
              };
            };

            extraConfig = ''
              # WM control center submap
              bind = $mod, X, exec, sleep 2 && hyprctl dispatch submap reset
              bind = $mod, X, submap, system_control
              submap = system_control

              # shut down computer
              bind = , ESCAPE, exec, systemctl poweroff
              bind = , ESCAPE, submap, reset

              # exit hyprland
              bind = , Q, exit
              bind = , Q, submap, reset

              # reload hyprland
              bind = , R, exec, hyprctl reload config-only
              bind = , R, submap, reset
              bind = $mod, R, exec, hyprctl reload
              bind = $mod, R, submap, reset

              # lockscreen
              bind = , L, exec, $lockscreen
              bind = , L, submap, reset

              bind = , catchall, submap, reset

              submap = reset
            '';
          };
        })
      ];

      # dependencies
      environment.systemPackages = with pkgs; [
        grimblast # screenshot
        wl-clipboard # clipboard manipulation tool
        cinnamon.nemo-with-extensions # GUI file explorer
      ];
    }
  ]);
}
