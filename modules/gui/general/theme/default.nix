{ lib }:

let
  cfg = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.theme = {
    # colors
    primary_color = lib.mkOption { type = lib.types.singleLineStr; default = "#1081d6"; };
    
    # borders
    unfocused_border_color = lib.mkOption { type = lib.types.singleLineStr; default = "#595959"; };
    focused_border_color = lib.mkOption { type = lib.types.singleLineStr; default = "#595959"; };
  };
}
