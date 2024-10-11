{
    home_manager_modules = [
      ({
        home.file.".config/rofi/drun.rasi".text = ''
          configuration {
            show-icons: true;
            icon-theme: "Papirus-Dark";
            monitor: "-1";
            case-sensitive: false;
            drun-display-format: "{name}";
            drun-match-fields: "name,generic,exec";
            sort: true;
            sorting-method: "fzf";
          }

          @theme "theme.rasi"

          window {
            width: 30%;
          }

          textbox-icon {
            expand: false;
            content: "";
            font: "symbols nerd font 16";
          }

          inputbar {
            children: [ "textbox-icon","entry" ];
          }
        '';
      })
    ];
}