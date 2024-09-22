{ theme }:
{
  #environment.systemPackages = with pkgs; [ foot ];

  home_manager_modules = [
    ({
      programs.foot = {
        enable = true;
        server.enable = false; # No server mode for simplicity

        # https://codeberg.org/dnkl/foot/raw/branch/master/foot.ini
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
            background = "${builtins.replaceStrings ["#"] [""] theme.bg1}";  # Background color
            foreground = "${builtins.replaceStrings ["#"] [""] theme.fg}";   # Foreground color

            #alpha = "1.0"; # Transparency level (1.0 = fully opaque)
            
            regular0 = "${builtins.replaceStrings ["#"] [""] theme.black}";   # Black
            regular1 = "${builtins.replaceStrings ["#"] [""] theme.red}";     # Red
            regular2 = "${builtins.replaceStrings ["#"] [""] theme.green}";   # Green
            regular3 = "${builtins.replaceStrings ["#"] [""] theme.yellow}";  # Yellow
            regular4 = "${builtins.replaceStrings ["#"] [""] theme.blue}";    # Blue
            regular5 = "${builtins.replaceStrings ["#"] [""] theme.magenta}"; # Magenta
            regular6 = "${builtins.replaceStrings ["#"] [""] theme.cyan}";    # Cyan
            regular7 = "${builtins.replaceStrings ["#"] [""] theme.white}";   # White

            bright0 = "${builtins.replaceStrings ["#"] [""] theme.black_light}";   # Bright black
            bright1 = "${builtins.replaceStrings ["#"] [""] theme.red_light}";     # Bright red
            bright2 = "${builtins.replaceStrings ["#"] [""] theme.green_light}";   # Bright green
            bright3 = "${builtins.replaceStrings ["#"] [""] theme.yellow_light}";  # Bright yellow
            bright4 = "${builtins.replaceStrings ["#"] [""] theme.blue_light}";    # Bright blue
            bright5 = "${builtins.replaceStrings ["#"] [""] theme.magenta_light}"; # Bright magenta
            bright6 = "${builtins.replaceStrings ["#"] [""] theme.cyan_light}";    # Bright cyan
            bright7 = "${builtins.replaceStrings ["#"] [""] theme.white_light}";   # Bright white

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

          key-bindings = {
            # Disable all keybindings
            clipboard-copy = "none";
            clipboard-paste = "none";
            spawn-terminal = "none";
            font-increase = "none";
            font-decrease = "none";
            font-reset = "none";
            scrollback-up-page = "none";
            scrollback-down-page = "none";
            search-start = "none";
            primary-paste = "none";
            unicode-input = "none";
            prompt-prev = "none";
            prompt-next = "none";
            show-urls-launch = "none";
            show-urls-copy = "none";
            # Disable all other keybindings as well
          };

          mouse-bindings = {
            # Disable all mouse bindings
            scrollback-up-mouse = "none";           # Disable scrollback up with mouse wheel
            scrollback-down-mouse = "none";         # Disable scrollback down with mouse wheel
            primary-paste = "none";                 # Disable middle click paste
            select-begin = "none";                  # Disable text selection on left-click
            select-begin-block = "none";            # Disable block selection with control + left-click
            select-extend = "none";                 # Disable extending selection on right-click
            select-extend-character-wise = "none";  # Disable character-wise selection on control + right-click
            select-word = "none";                   # Disable word selection on double-click
            select-word-whitespace = "none";        # Disable word selection with control + double-click
            select-quote = "none";                  # Disable quote selection on triple-click
            select-row = "none";                    # Disable row selection on quadruple-click
            font-increase = "none";                 # Disable font increase with mouse wheel + control
            font-decrease = "none";                 # Disable font decrease with mouse wheel + control
          };

          # URL detection settings
          url = {
            #launch = "xdg-open ${url}"; # Default URL handler
            #label-letters = "sadfjklewcmpgh"; # Letters for URL labels
            #osc8-underline = "url-mode"; # Underline style for URLs
            #protocols = "http,https"; # List of protocols to detect
            #uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
          };
        };
      };
    })
  ];
}