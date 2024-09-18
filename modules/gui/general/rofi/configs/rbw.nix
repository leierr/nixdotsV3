{ pkgs }:
let
    rofi_rbw_script = pkgs.writeShellScriptBin "rofi-rbw" ''
        #!/usr/bin/env bash

        if [[ -n ''${WAYLAND_DISPLAY} && ''${XDG_SESSION_TYPE} == "wayland" ]]
        then
            clipboard_utility="wl-copy"
        else
            clipboard_utility="xclip -i -selection c"
        fi

        rbw unlock
        passphrase=$(rbw list | rofi -dmenu -i -config ~/.config/rofi/rbw.rasi | xargs -I{} rbw get "{}")
        [[ -n "$passphrase" ]] && echo -n $passphrase | ''${clipboard_utility}
        unset passphrase
    '';
in
{
    environment.systemPackages = [ pkgs.rbw rofi_rbw_script ];

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
                width: 22%;
            }

            listview {
                fixed-height: false;
                dynamic: true;
                require-input: false;
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