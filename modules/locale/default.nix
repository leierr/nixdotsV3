{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.locale;
in
{
  options.system_settings.locale.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    # Configure console keymap & font
    console = {
      earlySetup = true;
      keyMap = "no";
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i20b.psf.gz";
    };

    #timezone
    time.timeZone = "Europe/Oslo";

    # locale
    i18n.defaultLocale = "en_US.UTF-8"; # this sets LANG
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_COLLATE = "nb_NO.UTF-8";
      LC_CTYPE = "en_US.UTF-8"; # LANG and LC_CTYPE should be the same
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MESSAGES = "en_US.UTF-8"; # this has to do with display language
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };

    # xserver defaults
    services.xserver.layout = "no";
    services.xserver.xkbVariant = "nodeadkeys";
  };
}
