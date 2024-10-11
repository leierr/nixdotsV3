{ lib, pkgs }:
{
    environment.systemPackages = [ pkgs.hypridle ];
    home_manager_modules = [
        ({
            services.hypridle = {
                enable = true;
                settings = {
                    general = {
                        before_sleep_cmd = "loginctl lock-session";
                        # after_sleep_cmd = "hyprctl dispatch dpms on";
                        ignore_dbus_inhibit = false;
                        lock_cmd = "pidof hyprlock || hyprlock";
                    };

                    listener = [
                        # 5 minutes
                        {
                            timeout = 300;
                            on-timeout = "loginctl lock-session";
                        }
                        {
                            timeout = 360;
                            # on-timeout = "hyprctl dispatch dpms off";
                            # on-resume = "hyprctl dispatch dpms on";
                        }
                    ];
                };
            };

            # disable the systemd service that comes with services.hyprpaper.enable
            systemd.user.services.hypridle = lib.mkForce {};
        })
    ];
}
