{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.pinentry;
in
{
  options.system_settings.gui.pinentry = {
    enable = lib.mkEnableOption "";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pinentry-gnome3;
    };
  };

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [ cfg.package ];
    
    # dependencies
    services.dbus.packages = [ pkgs.gcr ];
    services.pcscd.enable = true;

    programs.gnupg.agent = { pinentryPackage = cfg.package; };

    home_manager_modules = [
      ({ programs.rbw.settings.pinentry = cfg.package; })
    ];
  };
}
