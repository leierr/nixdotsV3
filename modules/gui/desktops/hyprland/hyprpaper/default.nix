{ lib, pkgs }:
{
  home_manager_modules = [
    ({
      services.hyprpaper = {
        enable = true;
        settings = {
          # disable IPC because I dont need it + battery consumption
          ipc = false;
          splash = false;
          preload = "${./wallpaper.jpg}";
          wallpaper = ",${./wallpaper.jpg}";
        };
      };

      # disable the systemd service that comes with services.hyprpaper.enable
      systemd.user.services.hyprpaper = lib.mkForce {};

      # launch hyprpaper from hyprland instead of systemd service
      wayland.windowManager.hyprland.settings.exec = [
        "pgrep hyprpaper || ${pkgs.hyprpaper}/bin/hyprpaper &"
      ];
    })
  ];
}

#Window 1aaafc70 -> All Files:
#        mapped: 1
#        hidden: 0
#        at: 1291,21
#        size: 1248,688
#        workspace: 7 (7)
#        floating: 0
#        pseudo: 0
#        monitor: 1
#        class: xdg-desktop-portal-gtk
#        title: All Files
#        initialClass: xdg-desktop-portal-gtk
#        initialTitle: All Files
#        pid: 2344
#        xwayland: 0
#        pinned: 0
#        fullscreen: 0
#        fullscreenmode: 0
#        fakefullscreen: 0
#        grouped: 0
#        tags:
#        swallowing: 0
#        focusHistoryID: 1