{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.module;
in
{
  options.system_settings.gui.module = {
    enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf (cfg.enable) {
    

    home_manager_modules = [
      ({_}:{})
    ];
  };
}
