{ config, pkgs }:
{
    environment.systemPackages = [ pkgs.rbw config.system_settings.gui.rofi.plugins.rbw.exec ];

    home_manager_modules = [
      ({
        home.file.".config/rofi/rbw.rasi".text = ''
            configuration {
                show-icons: false;
                monitor: "-1";
                case-sensitive: false;
                sort: true;
                sorting-method: "fzf";
            }

            @theme "theme.rasi"

            window {
                width: 30%;
            }

            textbox-icon {
            expand: false;
            content: "";
            font: "symbols nerd font 16";
            text-color: @blue;
            }

            inputbar {
                children: [ "textbox-icon","entry" ];
            }
        '';
      })
    ];
}