{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.pinentry;
in
{
  options.system_settings.gui.pinentry = {
    enable = lib.mkEnableOption "";

    package = lib.mkOption {
      type = lib.types.enum [ "gnome3" "curses" "tty" "gtk2" "emacs" "qt" ];
      default = "gnome3";
    };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # dependencies
    services.dbus.packages = [ pkgs.gcr ];
    services.pcscd.enable = true;

    programs.gnupg.agent = { pinentryPackage = cfg.package; };

    home_manager_modules = [
      ({ programs.rbw.settings.pinentry = pkgs.pinentry.${cfg.package}; })
    ];
  };
}
