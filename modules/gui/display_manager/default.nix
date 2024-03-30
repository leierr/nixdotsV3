{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.display_manager;
in
{
  options.system_settings.gui.display_manager = {
    enable = lib.mkEnableOption "";
    program = lib.mkOption { type = lib.types.enum [ "gdm" ]; default = "gdm"; };
    default_session = lib.mkOption { type = lib.types.nullOr lib.types.singleLineStr; default = null; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) lib.mkMerge [
    (lib.mkIf (cfg.program == "gdm") (import ./gdm.nix { inherit cfg; }) )
  ];
}
