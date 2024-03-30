{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.virtualization;
in
{
  options.system_settings.virtualization = {
    libvirt = {
      enable = lib.mkEnableOption "";
      virt_manager.enable = lib.mkOption { type = lib.types.bool; default = false; };
    };

    docker = {
      enable = lib.mkEnableOption "";
      docker_compose.enable = lib.mkOption { type = lib.types.bool; default = false; };
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
      lib.optionals (cfg.libvirt.enable && cfg.libvirt.virt_manager.enable) [ virt-manager ] 
      ++ lib.optionals (cfg.docker.enable && cfg.docker.docker_compose.enable) [ docker-compose ];
  };
}
