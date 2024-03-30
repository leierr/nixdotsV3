{ pkgs, ... }:
{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix> ];

  # remove a bunch of gnome bloat
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    xterm
    gnome-connections
    gnome.gnome-shell-extensions
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    simple-scan # document scanner
    gnome-weather # gnome weather app
    gnome-contacts # GNOME’s integrated address book
    gnome-maps # A map application for GNOME 3
    yelp # gnome help page
  ]);

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

  networking = {
    hostName = "iso";
  };

  # gnome power settings do not turn off screen
  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  # extra packages
  environment.systemPackages = with pkgs; [
    firefox
    jq
  ] ++ [
    (pkgs.writeShellScriptBin "nix_installer" ( builtins.readFile ./scripts/install_nixos.sh ))
  ];

  # saving myself some time
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # prefered editor
  programs.neovim = { enable = true; viAlias = true; vimAlias = true; defaultEditor = true; withPython3 = false; withNodeJs = false; withRuby = false; };
}
