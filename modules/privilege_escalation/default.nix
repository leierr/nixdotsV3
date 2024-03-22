{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.privilege_escalation;

  doas_config = {
    security.doas = {
      enable = true;
      wheelNeedsPassword = cfg.wheel_needs_password;
    };

    # sudo -> doas alias
    environment.interactiveShellInit = ''alias sudo="doas"'';

    security.sudo.enable = false;
  };

  sudo_config = {
    security.sudo = {
      enable = true;
      wheelNeedsPassword = cfg.wheel_needs_password;
    };

    security.doas.enable = false;
  };
in
{
  options.system_settings.privilege_escalation = {
    enable = lib.mkEnableOption null;

    program = lib.mkOption { type = lib.types.enum [ "sudo" "doas" ]; default = "doas"; };

    wheel_needs_password = lib.mkOption { type = lib.types.bool; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.program == "doas") doas_config)
    (lib.mkIf (cfg.program == "sudo") sudo_config)
  ]);
}
