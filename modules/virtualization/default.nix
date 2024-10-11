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
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };

    home_manager_modules = [
      ({
        dconf = lib.mkIf (cfg.libvirt.enable && cfg.libvirt.virt_manager.enable) {
          settings."org/virt-manager/virt-manager/connections".uris = [ "qemu:///session" ];
          settings."org/virt-manager/virt-manager/connections".autoconnect = [ "qemu:///session" ];
        };

        home.file.".config/libvirt/qemu.conf".text = ''
          nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
        '';
      })
    ];

    networking.firewall.trustedInterfaces = lib.mkIf cfg.libvirt.enable [ "virbr0" ];

    virtualisation.docker.rootless = lib.mkIf cfg.docker.enable {
      enable = true;
      setSocketVariable = true;
    };

    environment.systemPackages = with pkgs;
      lib.optionals (cfg.libvirt.enable && cfg.libvirt.virt_manager.enable) [ virt-manager ] 
      ++ lib.optionals (cfg.docker.enable && cfg.docker.docker_compose.enable) [ docker-compose ];
  };
}
