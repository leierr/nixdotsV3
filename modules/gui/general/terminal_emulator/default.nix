{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.terminal_emulator;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.terminal_emulator = {
    wayland.enable = lib.mkEnableOption "";
    wayland.exec = lib.mkOption { type = lib.types.str; default = "foot"; };
    x11.enable = lib.mkEnableOption "";
  };

  config = lib.mkIf ((cfg.wayland.enable || cfg.x11.enable)) (lib.mkMerge [
    (lib.mkIf cfg.wayland.enable (import ./wayland { inherit theme; }))
  ]);
}
