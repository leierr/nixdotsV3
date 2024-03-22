{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui;
in
{
  options.system_settings.gui = import ./options.nix { inherit lib pkgs; };

  imports = lib.mkIf cfg.enable [
    ./sub_modules/qt
    ./sub_modules/gtk
    #./sub_modules/pinentry
  ];

  config = {};
}
