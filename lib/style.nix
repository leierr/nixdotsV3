{ lib }:
{
  # colors
  primary_color = lib.mkOption { type = lib.types.singleLineStr; default = "#1081d6"; };
  
  # borders
  unfocused_border_color = lib.mkOption { type = lib.types.singleLineStr; default = "#595959"; };
  focused_border_color = lib.mkOption { type = lib.types.singleLineStr; default = "#595959"; };
}