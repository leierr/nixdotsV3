{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.applauncher;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.applauncher = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    environment.systemPackages = with pkgs; [
      # dependencies to run correctly
      rofi-wayland
      hack-font
      nerdfonts
      papirus-icon-theme
    ];

    home.file.".config/rofi/drun.rasi".text = ''
      ! Rofi main config
      configuration {
        show-icons: true;
        icon-theme: "Papirus-Dark";
        monitor: "-1";
        case-sensitive: false;
        drun-display-format: "{name}";
        drun-match-fields: "name,generic,exec";
        terminal: "alacritty";
        sort: true;
        sorting-method: "fzf";
      }

      @theme "theme.rasi"

      window {
        width: 24%;
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

    home.file.".config/rofi/theme.rasi".text = ''
    * {
        black: ${theme.black};
        red: ${theme.red};
        green: ${theme.green};
        yellow: ${theme.yellow};
        blue: ${theme.blue};
        magenta: ${theme.magenta};
        cyan: ${theme.cyan};
        white: ${theme.white};
        gray: ${theme.gray};
        background: ${theme.bg1};
        background2: ${theme.bg2};
        foreground: ${theme.fg};
        //
        separatorcolor: @foreground;
        border-color: @foreground;
        selected-normal-foreground: @foreground;
        selected-normal-background: @background2;
        selected-active-foreground: @foreground;
        selected-active-background: @background;
        selected-urgent-foreground: @background;
        selected-urgent-background: @red;
        normal-foreground: @selected-normal-foreground;
        normal-background: @selected-normal-background;
        active-foreground: @selected-active-foreground;
        active-background: @selected-active-background;
        urgent-foreground: @selected-urgent-background;
        urgent-background: @selected-urgent-foreground;
        //
        background-color: @background;
        text-color: @foreground;
        font: "Hack 16";
    }

    element {
        padding: 0.9%;
        cursor: pointer;
        spacing: 0.5em;
        border: 0;
        border-radius: 0.4em;
    }

    element.normal.urgent {
        background-color: var(urgent-background);
        text-color: var(urgent-foreground);
    }

    element.normal.active {
        background-color: var(active-background);
        text-color: var(active-foreground);
    }

    element.selected.normal {
        background-color: var(selected-normal-background);
        text-color: var(selected-normal-foreground);
    }

    element.selected.urgent {
        background-color: var(selected-urgent-background);
        text-color: var(selected-urgent-foreground);
    }

    element.selected.active {
        background-color: var(selected-active-background);
        text-color: var(selected-active-foreground);
    }

    element.alternate.urgent {
        background-color: var(urgent-background);
        text-color: var(urgent-foreground);
    }

    element.alternate.active {
        background-color: var(active-background);
        text-color: var(active-foreground);
    }

    element-text {
        background-color: inherit;
        cursor: inherit;
        highlight: inherit;
        text-color: inherit;
    }

    element-index {
        background-color: inherit;
        cursor: inherit;
        highlight: inherit;
        text-color: inherit;
    }

    element-icon {
        background-color: rgba (0,0,0,0%);
        size: 1em;
    }

    textbox {
        background-color: var(active-background);
        text-color: var(active-foreground);
    }

    window {
        y-offset: -10%;
        padding: 2% 1%;
        border-radius: 0.8em;
        border: 2px;
        border-color: var(normal-background);
        location: center;
        anchor: north;
        transparency: "real"; // requires picom
    }

    listview {
        padding: 0;
        border: 0;
        scrollbar: false;
        spacing: 0.2%;
        //
        lines: 7;
        fixed-height: false;
        dynamic: false;
        columns: 1;
        cycle: true;
        require-input: false;
    }

    button {
        cursor: pointer;
        spacing: 0;
    }

    button selected {
        background-color: var(selected-normal-background);
        text-color: var(selected-normal-foreground);
    }

    inputbar {
        padding: 1.2% 0.8%;
        spacing: 0.5em;
        border: 0;
        children: [ "entry" ];
    }
    '';
  };
}
