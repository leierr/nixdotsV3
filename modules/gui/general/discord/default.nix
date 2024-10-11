{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.discord;
in
{
  options.system_settings.gui.discord = {
    enable = lib.mkEnableOption "";
    vesktop = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = if cfg.vesktop then [ pkgs.vesktop ] else [ pkgs.discord ];

    # fuck it vi lager overlay. Du velger Discord ELLER Vesktop
    nixpkgs.overlays = if !cfg.vesktop then [] else [
      (final: prev:
      {
        vesktop = prev.vesktop.overrideAttrs (old: {
          desktopItems = [
            (pkgs.makeDesktopItem {
              name = "discord";
              exec = "vesktop %U";
              icon = "discord";
              desktopName = "Discord";
              genericName = "All-in-one cross-platform voice and text chat for gamers";
              categories = [ "Network" "InstantMessaging" ];
              mimeTypes = [ "x-scheme-handler/discord" ];
            })
          ];
        });
      })
    ];
  };
}
