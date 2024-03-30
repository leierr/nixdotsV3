{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.pinentry;
in
{
  options.system_settings.gui.pinentry = {
    enable = lib.mkEnableOption "";

    flavor = lib.mkOption {
      type = lib.types.enum [ "gnome3" "curses" "tty" "gtk2" "emacs" "qt" ];
      default = "gnome3";
    };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # dependencies
    services.dbus.packages = [ pkgs.gcr ];
    services.pcscd.enable = true;

    programs.gnupg.agent = { pinentryFlavor = cfg.flavor; };

    home_manager_modules = [
      ({ programs.rbw.settings.pinentry = pkgs.pinentry.${cfg.flavor}; })
    ];
  };
}
