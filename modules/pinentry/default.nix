{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.pinentry;
in
{
  options.system_settings.pinentry = {
    enable = lib.mkEnableOption null;

    flavor = lib.mkOption {
      type = lib.types.enum [ "gnome3" "curses" "tty" "gtk2" "emacs" "qt" ];
      default = "gnome3";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ pkgs.gcr ]; # dependency
    programs.gnupg.agent.pinentryFlavor = cfg.flavor;

    home_manager_modules = [
      ({...}:{ programs.rbw.settings.pinentry = pkgs.pinentry.${cfg.flavor}; })
    ];
  };
}
