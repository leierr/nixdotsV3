{ theme }:
{
  home_manager_modules = [
    ({
      services.hyprpaper = {
        enable = true;
        settings = {
          # disable IPC because I dont need it + battery consumption
          ipc = false;
          splash = false;
          preload = "${theme.wallpaper_jpg}";
          wallpaper = ",${theme.wallpaper_jpg}";
        };
      };

      # disable the systemd service that comes with services.hyprpaper.enable
      systemd.user.services.hyprpaper = lib.mkForce {};
    })
  ];
}
