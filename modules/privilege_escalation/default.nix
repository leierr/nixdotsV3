{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.privilege_escalation;
in
{
  options.system_settings.privilege_escalation = {
    enable = lib.mkEnableOption "";

    program = lib.mkOption { type = lib.types.enum [ "sudo" "doas" ]; default = "doas"; };
    wheel_needs_password = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.program == "doas") (import ./doas.nix { inherit cfg lib; }) )
    (lib.mkIf (cfg.program == "sudo") (import ./sudo.nix { inherit cfg; }) )
  ]);
}
