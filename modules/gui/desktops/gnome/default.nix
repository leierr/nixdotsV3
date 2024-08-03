{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui.desktops.gnome;
  theme = config.system_settings.gui.theme;
  hexToRGBA = (import (inputs.self + "/helper_functions/hex_to_rgba.nix") { inherit lib; });
in
{
  options.system_settings.gui.desktops.gnome = {
    enable = lib.mkEnableOption "";
  };

  config = {
    # install gnome globally
    services.xserver.desktopManager.gnome.enable = true;

    # cool nautilus picture/video previewer
    services.gnome.sushi.enable = true;

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos # gnome photo viewer
      gnome-tour # gnome tutorial
      gedit # text editor
      geary # email reader
      totem # video player
      epiphany # web browser
      gnome-terminal # default gnome terminal
      cheese # webcam tool
      ]) ++ (with pkgs.gnome; [
      gnome-music
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

    home_manager_modules = [
      ({
        dconf = {
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
          settings."org/gnome/Weather".locations = ''[<(uint32 2, <('Oslo', 'ENGM', true, [(1, 0)], [(1, 0)])>)>]'';
        };
      })
    ];
  };
}
