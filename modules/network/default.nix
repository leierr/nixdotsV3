{ config, lib, ... }:

let
  cfg = config.system_settings.network;
in
{
  options.system_settings.network = {
    enable = lib.mkEnableOption null;
    ipv6.enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd"; # stable = wpa_supplicant
          powersave = false;
          macAddress = "stable";
        };
        dhcp = "internal";
        dns = "default";
        ethernet.macAddress = "stable";
        logLevel = "WARN";
        extraConfig = ''
          [main]
          no-auto-default=*
        '';
      };
      useNetworkd = false; # om jeg ikke hadde hatt vpn setup hadde jeg brukt den
      enableIPv6 = cfg.ipv6.enable; # all my homies use ipv4
      dhcpcd.enable = false; # vet ikke hvorfor NixOS enda har dhcpd som default enabled...
      useDHCP = false;
      firewall = {
        enable = true;
        # allowedTCPPorts = [ 80 443 ];
      };
      nftables = {
        enable = true;
        ruleset = "";
      };
    };
  };
}
