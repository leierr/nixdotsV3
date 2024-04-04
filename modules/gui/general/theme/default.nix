{ lib, config, ... }:

let
  cfg = config.system_settings.gui.theme;

  hexToRGBA = hex: let
    hexToDec = h: lib.parseInt h;
    r = hexToDec (lib.substring 1 2 hex);
    g = hexToDec (lib.substring 3 2 hex);
    b = hexToDec (lib.substring 5 2 hex);
  in
    "rgba(${toString r}, ${toString g}, ${toString b}, 1)";

  create_color = name: hex: {
    "${name}.hex" = lib.mkOption { type = lib.types.singleLineStr; default = hex; };
    "${name}.rgba" = lib.mkOption { type = lib.types.singleLineStr; default = (hexToRGBA hex); };
  };
in
{
  options.system_settings.gui.theme = (lib.mkMerge [
    (create_color "primary_color" "#1081d6")

    (create_color "fg" "#f1f1f1")
    
    (create_color "bg" "#121212")
    (create_color "bg2" "#292929")
    (create_color "bg3" "#414141")
    (create_color "bg4" "#595959")
    (create_color "bg5" "#707070")
    (create_color "bg6" "#888888")
    (create_color "bg7" "#a0a0a0")
    (create_color "bg8" "#b7b7b7")
    
    (create_color "unfocused_border_color" "#595959")
    (create_color "focused_border_color" "#595959")
  ]).contents;
}

/* primary/selected color */
/* foreground */
/* backgrounds */
/* the rest */