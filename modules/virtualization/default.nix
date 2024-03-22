{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.virtualization;
in
{
  options.system_settings.virtualization = {
    libvirt = {
      enable = lib.mkEnableOption null;

      virt_manager = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install and virt-manager";
      };
    };

    docker = {
      enable = lib.mkEnableOption null;

      docker_compose = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install and configure docker compose";
      };
    };
  };

  config = {
    virtualisation.libvirtd = lib.mkIf cfg.libvirt.enable {
      enable = true;
      # do not start libvirtd.service on boot
      onBoot = "ignore";
      # shutdown virtual hosts with physical host.
      onShutdown = "shutdown";
      # simple networking
      allowedBridges = [ "virbr0" ];
    };

    virtualisation.docker.rootless = lib.mkIf cfg.docker.enable {
      enable = true;
      setSocketVariable = true;
    };

    environment.systemPackages = with pkgs;
      lib.optionals (cfg.libvirt.enable && cfg.libvirt.virt_manager) [ virt-manager ] 
      ++ lib.optionals (cfg.docker.enable && cfg.docker.docker_compose) [ docker-compose ];
  };
}
