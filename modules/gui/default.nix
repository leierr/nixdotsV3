{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui;
in
{
  options.system_settings.gui = {
    enable = lib.mkEnableOption null;
    display_manager = {
      program = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "gdm" ]);
        default = null;
      };

      default_session = lib.mkOption {
        type = lib.types.nullOr lib.types.singleLineStr;
        default = null;
      };
    };
  };

  imports = import ./imports.nix;

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # display managers
    (lib.mkIf ( cfg.display_manager.program == "gdm" ) { system_settings.gui.gdm.enable = true; })

    # desktops
  ]);  
}
