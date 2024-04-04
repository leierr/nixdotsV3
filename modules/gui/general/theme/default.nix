{ lib, config, ... }:

let
  cfg = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.theme = {
    # Primary/selected color
    primary_color = lib.mkOption { type = lib.types.str; default = "#1081d6"; };

    # Foreground
    fg = lib.mkOption { type = lib.types.str; default = "#f1f1f1"; };

    # Backgrounds
    bg = lib.mkOption { type = lib.types.str; default = "#121212"; };
    bg2 = lib.mkOption { type = lib.types.str; default = "#292929"; };
    bg3 = lib.mkOption { type = lib.types.str; default = "#414141"; };
    bg4 = lib.mkOption { type = lib.types.str; default = "#595959"; };
    bg5 = lib.mkOption { type = lib.types.str; default = "#707070"; };
    bg6 = lib.mkOption { type = lib.types.str; default = "#888888"; };
    bg7 = lib.mkOption { type = lib.types.str; default = "#a0a0a0"; };
    bg8 = lib.mkOption { type = lib.types.str; default = "#b7b7b7"; };

    # The rest
    unfocused_border_color = lib.mkOption { type = lib.types.str; default = "#595959"; };
    focused_border_color = lib.mkOption { type = lib.types.str; default = "#595959"; };
  };
}
