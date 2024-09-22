{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.terminal_emulator;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.terminal_emulator = {
    wayland.enable = lib.mkEnableOption "";
    wayland.exec = lib.mkOption { type = lib.types.str; default = "foot"; }
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    #environment.systemPackages = with pkgs; [ foot ];

    home_manager_modules = [
      ({
        programs.foot = {
          enable = true;
          server.enable = false; # No server mode for simplicity

          settings = {
            # Main settings
            main = {
              font = "Hack:size=13"; # Using the Hack font with size 13
              dpi-aware = "yes"; # Automatically adjust based on DPI
              term = "xterm-256color"; # Terminal type, defaults to foot or xterm-256color
              #login-shell = "no"; # Whether to start as a login shell
              #initial-window-size-pixels = "700x500"; # Initial window size in pixels
              #initial-window-size-chars = "80x24";    # Initial window size in characters
            };

            # Color settings
            colors = {
              background = theme.bg1;  # Background color
              foreground = theme.fg;   # Foreground color
              #alpha = "1.0";            # Transparency level (1.0 = fully opaque)
              regular0 = theme.black;   # Color palette settings
              regular1 = theme.red;
              regular2 = theme.green;
              regular3 = theme.yellow;
              regular4 = theme.blue;
              regular5 = theme.magenta;
              regular6 = theme.cyan;
              regular7 = theme.white;

              bright0 = theme.black_light;
              bright1 = theme.red_light;
              bright2 = theme.green_light;
              bright3 = theme.yellow_light;
              bright4 = theme.blue_light;
              bright5 = theme.magenta_light;
              bright6 = theme.cyan_light;
              bright7 = theme.white_light;

              #selection-foreground = ""; # Foreground color for selection
              #selection-background = ""; # Background color for selection
              #scrollback-indicator = ""; # Indicator for scrollback
              #urls = "";                 # Color for URLs
            };

            # Cursor settings
            cursor = {
              style = "beam"; # Cursor style (block, beam, underline)
              blink = "no"; # Disable blinking for simplicity
              #blink-rate = "500";    # Blink rate in ms
              #beam-thickness = "1.5"; # Thickness of the beam cursor
              #underline-thickness = ""; # Thickness of the underline cursor
              #color = "";            # Custom cursor color
            };

            # Scrollback settings
            scrollback = {
              #lines = "1000";             # Number of scrollback lines
              #multiplier = "3.0";         # Scroll multiplier
              #indicator-position = "relative"; # Scrollback indicator position
              #indicator-format = "";      # Scrollback indicator format
            };

            # Mouse settings
            mouse = {
              #hide-when-typing = "no";     # Hide the mouse cursor while typing
              #alternate-scroll-mode = "yes"; # Alternate scroll mode when using the mouse wheel
            };

            # CSD (Client-side decorations)
            csd = {
              size = 0;              # Border size
              #font = "";             # Custom font for title bar
              #color = "";            # Color for title bar
              #hide-when-maximized = "no"; # Hide CSD when maximized
              #double-click-to-maximize = "yes"; # Enable double-click to maximize
              #border-width = "0";    # Border width around the window
              #button-width = "26";   # Button width (close, maximize, minimize)
              #button-minimize-color = theme.blue; # Button color for minimize
              #button-maximize-color = theme.green; # Button color for maximize
              #button-close-color = theme.red; # Button color for close
            };

            # Keybindings (we are disabling all)
            key-bindings = {
              noop = "all";          # Disable all keybindings
              #scrollback-up-page = "Shift+Page_Up";
              #scrollback-down-page = "Shift+Page_Down";
              #clipboard-copy = "Control+Shift+c XF86Copy";
              #clipboard-paste = "Control+Shift+v XF86Paste";
              #primary-paste = "Shift+Insert";
              #font-increase = "Control+plus Control+equal Control+KP_Add";
              #font-decrease = "Control+minus Control+KP_Subtract";
              #font-reset = "Control+0 Control+KP_0";
              #spawn-terminal = "Control+Shift+n";
            };

            # Mouse Bindings (disabled)
            mouse-bindings = {
              noop = "all";          # Disable all mouse bindings
              #scrollback-up-mouse = "BTN_WHEEL_BACK";
              #scrollback-down-mouse = "BTN_WHEEL_FORWARD";
              #primary-paste = "BTN_MIDDLE";
              #select-begin = "BTN_LEFT";
            };

            # URL detection settings
            url = {
              #launch = "xdg-open ${url}"; # Default URL handler
              #label-letters = "sadfjklewcmpgh"; # Letters for URL labels
              #osc8-underline = "url-mode"; # Underline style for URLs
              #protocols = "http,https"; # List of protocols to detect
              #uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
            };

            # Touch settings
            touch = {
              #long-press-delay = "400";   # Long press delay in ms
            };

            # Shell integration
            shell = {
              #osc-7 = "";                # Current working directory integration
              #osc-133 = "";              # Prompt detection integration
              #pipe-command-output = "Control+Shift+g"; # Pipe last command's output
            };
          };
        };
      })
    ];
  };
}
