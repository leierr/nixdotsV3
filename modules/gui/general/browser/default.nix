{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.system_settings.gui.browser;
in
{
  options.system_settings.gui.browser = {
    enable = lib.mkEnableOption "";
    firefox.enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) (lib.mkMerge [
    (lib.mkIf cfg.firefox.enable (import ./firefox.nix { inherit cfg pkgs inputs; }))
  ]);
}
