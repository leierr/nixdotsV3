{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.privilege_escalation;
in
{
  options.system_settings.privilege_escalation = {
    # required
    enable = lib.mkEnableOption "";

    # not required
    program = lib.mkOption { type = lib.types.enum [ "sudo" "doas" ]; default = "doas"; };
    wheel_needs_password = lib.mkOption { type = lib.types.bool; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.program == "doas") {
      security.doas = {
        enable = true;
        wheelNeedsPassword = cfg.wheel_needs_password;
      };

      # sudo -> doas alias
      environment.interactiveShellInit = ''alias sudo="doas"'';

      security.sudo.enable = false;
    });

    (lib.mkIf (cfg.program == "sudo") {
      security.sudo = {
        enable = true;
        wheelNeedsPassword = cfg.wheel_needs_password;
      };

      security.doas.enable = false;
    });
  ]);
}
