{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.pinentry;
in
{
  options.system_settings.gui.pinentry = {
    enable = lib.mkOption { type = lib.types.bool; default = true; };

    flavor = lib.mkOption {
      type = lib.types.enum [ "gnome3" "curses" "tty" "gtk2" "emacs" "qt" ];
      default = "gnome3";
    };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    services.dbus.packages = [ pkgs.gcr ]; # dependency
    programs.gnupg.agent.pinentryFlavor = cfg.flavor;

    home_manager_modules = [
      ({ programs.rbw.settings.pinentry = pkgs.pinentry.${cfg.flavor}; })
    ];
  };
}
