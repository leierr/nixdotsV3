{ config, lib, ... }:

let
  cfg = config.system_settings.nix;
in
{
  options.system_settings.nix = {
    enable = lib.mkEnableOption null;

    garbage_collection = {
      automatic = lib.mkOption { type = lib.types.bool; default = true; };

      dates = lib.mkOption { type = lib.types.str; default = "weekly"; };

      extra_options = lib.mkOption { type = lib.types.str; default = "--delete-older-than 7d"; };
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      gc = lib.mkIf cfg.garbage_collection.automatic {
        automatic = true;
        dates = cfg.garbage_collection.dates;
        options = cfg.garbage_collection.extra_options;
      };

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        #access-tokens = "";
      };
    };
  };
}
