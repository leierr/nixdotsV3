{ theme }:
{
  home_manager_modules = [
    ({
      programs.foot = {
        enable = true;
        server.enable = false; # No server mode for simplicity

        # https://codeberg.org/dnkl/foot/raw/branch/master/foot.ini
        settings = {
          main = {
            term = "xterm-256color"; # default: foot
            login-shell = "no";
            app-id = "foot";
            title = "foot";
            locked-title = "yes"; # less overhead
            font = "Hack:size=14";
            font-size-adjustment = 0.5;
            bold-text-in-bright = "no";
            dpi-aware = "no";
            pad = "0x0";
            resize-by-cells = "yes";
            resize-delay-ms = 100;
          };

          colors = { 
            background = "${builtins.replaceStrings ["#"] [""] theme.bg1}";  # Background color
            foreground = "${builtins.replaceStrings ["#"] [""] theme.fg}";   # Foreground color

            alpha = "1.0"; # Transparency level (1.0 = fully opaque)
            
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

            ## Misc colors
            # selection-foreground=<inverse foreground/background>
            # selection-background=<inverse foreground/background>
            # jump-labels=<regular0> <regular3>          # black-on-yellow
            # scrollback-indicator=<regular0> <bright4>  # black-on-bright-blue
            # search-box-no-match=<regular0> <regular1>  # black-on-red
            # search-box-match=<regular0> <regular3>     # black-on-yellow
            # urls=<regular3>
          };

          # not needed
          environment = {};
          # uses WM provided window decorations by default <3
          csd = {};
           # default disabled
          bell = {};
          # sensible defaults thus far
          # desktop-notifications = {}; invalid section name: desktop-notifications???
          mouse = {};
          cursor = {};
          touch = {};
          url = {};
          url-bindings = {};

          scrollback = {
            lines=100000;
            multiplier = 3.0;
          };

          key-bindings = {
            show-urls-launch = "Control+Shift+l"; # show-urls-copy, show-urls-persistent
            scrollback-up-page = "Shift+Page_Up";
            scrollback-down-page = "Shift+Page_Down";
            clipboard-copy = "Control+Shift+c XF86Copy";
            clipboard-paste = "Control+Shift+v XF86Paste";
            search-start = "Control+Shift+r";
            font-increase = "Control+plus";
            font-decrease = "Control+minus";
            font-reset = "Control+0";
            # disable everything except what I actually use.
            noop = "none";
            scrollback-up-half-page = "none";
            scrollback-up-line = "none";
            scrollback-down-half-page = "none";
            scrollback-down-line = "none";
            scrollback-home = "none";
            scrollback-end = "none";
            primary-paste = "none";
            spawn-terminal = "none";
            minimize = "none";
            maximize = "none";
            fullscreen = "none";
            pipe-visible = "none";
            pipe-scrollback = "none";
            pipe-selected = "none";
            pipe-command-output = "none";
            show-urls-persistent = "none";
            show-urls-copy = "none";
            prompt-prev = "none";
            prompt-next = "none";
            unicode-input = "none";
            quit = "none";
          };

          mouse-bindings = {
            scrollback-down-mouse = "BTN_FORWARD";
            scrollback-up-mouse = "BTN_BACK";
            selection-override-modifiers = "Shift";
            select-begin = "BTN_LEFT";
            select-begin-block = "Control+BTN_LEFT";
            select-word = "none"; select-word-whitespace = "BTN_LEFT-2"; # usually Control+BTN_LEFT-2
            select-row = "BTN_LEFT-3";
            # disable everything except what I actually use.
            primary-paste = "none";
            font-increase = "none";
            font-decrease = "none";
            select-quote = "none";
            select-extend = "none";
            select-extend-character-wise = "none";
          };

          search-bindings = {
            cancel = "Control+g Control+c Escape";
            commit = "Return";
            find-next = "Control+n";
            find-prev = "Control+p";
            cursor-left = "Left";
            cursor-left-word = "Control+Left";
            cursor-right = "Right";
            cursor-right-word = "Control+Right";
            delete-prev = "BackSpace";
            delete-prev-word = "Control+BackSpace";
            clipboard-paste = "Control+Shift+v";
            # disable everything except what I actually use.
            cursor-home = "none";
            cursor-end = "none";
            delete-next = "none";
            delete-next-word = "none";
            extend-char = "none";
            extend-to-word-boundary = "none";
            extend-to-next-whitespace = "none";
            extend-line-down = "none";
            extend-backward-char = "none";
            extend-backward-to-word-boundary = "none";
            extend-backward-to-next-whitespace = "none";
            extend-line-up = "none";
            primary-paste = "none";
            unicode-input = "none";
            scrollback-up-page = "none";
            scrollback-up-half-page = "none";
            scrollback-up-line = "none";
            scrollback-down-page = "none";
            scrollback-down-half-page = "none";
            scrollback-down-line = "none";
            scrollback-home = "none";
            scrollback-end = "none";
          };
        };
      };
    })
  ];
}
