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
