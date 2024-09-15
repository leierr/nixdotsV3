{ lib, config, ... }:

let
  cfg = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.theme = {
    # Primary/Selected Color
    primary_color = lib.mkOption { type = lib.types.str; default = "#0E66D0"; };

    # Foreground
    fg = lib.mkOption { type = lib.types.str; default = "#f1f1f1"; };

    # Backgrounds
    bg1 = lib.mkOption { type = lib.types.str; default = "#1C1C1C"; };
    bg2 = lib.mkOption { type = lib.types.str; default = "#2F2F2F"; };
    bg3 = lib.mkOption { type = lib.types.str; default = "#3A3A3A"; };
    bg4 = lib.mkOption { type = lib.types.str; default = "#474747"; };
    bg5 = lib.mkOption { type = lib.types.str; default = "#515151"; };

    # Borders
    unfocused_border_color = lib.mkOption { type = lib.types.str; default = "#595959"; };
    focused_border_color = lib.mkOption { type = lib.types.str; default = cfg.primary_color; };

    # Additional Colors with Light Variants
    black = lib.mkOption { type = lib.types.str; default = "#1e1e1e"; };
    black_light = lib.mkOption { type = lib.types.str; default = "#323232"; };

    blue = lib.mkOption { type = lib.types.str; default = "#0E66D0"; };
    blue_light = lib.mkOption { type = lib.types.str; default = "#0875F6"; };

    cyan = lib.mkOption { type = lib.types.str; default = "#4BB0E3"; };
    cyan_light = lib.mkOption { type = lib.types.str; default = "#4FC0F7"; };

    green = lib.mkOption { type = lib.types.str; default = "#2BBF3E"; };
    green_light = lib.mkOption { type = lib.types.str; default = "#2DD042"; };

    magenta = lib.mkOption { type = lib.types.str; default = "#9C48CC"; };
    magenta_light = lib.mkOption { type = lib.types.str; default = "#B24FEA"; };

    red = lib.mkOption { type = lib.types.str; default = "#F13A31"; };
    red_light = lib.mkOption { type = lib.types.str; default = "#FE3C33"; };

    white = lib.mkOption { type = lib.types.str; default = "#F1F1F1"; };
    white_light = lib.mkOption { type = lib.types.str; default = "#FEFEFE"; };

    yellow = lib.mkOption { type = lib.types.str; default = "#F1C50F"; };
    yellow_light = lib.mkOption { type = lib.types.str; default = "#FECF0F"; };
  };
}

