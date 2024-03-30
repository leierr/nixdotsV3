{ pkgs, ... }:
{
  console = {
    earlySetup = true;
    keyMap = "no";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
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

  networking = {
    hostName = "iso";
  };

  # extra packages
  environment.systemPackages = with pkgs; [
   jq git
  ] ++ [
    (pkgs.writeShellScriptBin "leier-nix-install" ( builtins.readFile ./scripts/install_nixos.sh ))
  ];

  # saving myself some time
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # prefered editor
  programs.neovim = { enable = true; viAlias = true; vimAlias = true; defaultEditor = true; withPython3 = false; withNodeJs = false; withRuby = false; };
}
