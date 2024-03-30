{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.user_account;
  # cool hack I found here: https://github.com/hmajid2301/dotfiles/blob/ec1360083906c2b44b17c338cab72ba7f7f0be72/nixos/users/haseeb.nix#L7
  if_groups_exists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.system_settings.user_account = {
    # required
    enable = lib.mkEnableOption "";
    username = lib.mkOption { type = lib.types.singleLineStr; };
    description = lib.mkOption { type = lib.types.nullOr(lib.types.singleLineStr); };
    
    # not required
    initialPassword = lib.mkOption { type = lib.types.nullOr(lib.types.singleLineStr); default = "123"; };
    shell = lib.mkOption { type = lib.types.shellPackage; default = pkgs.bash; };
    home_directory = lib.mkOption { type = lib.types.singleLineStr; default = "/home/${cfg.username}"; };

    secondary_groups = lib.mkOption {
      type = lib.types.listOf(lib.types.str);
      default = if_groups_exists [
        "wheel"
        "video"
        "audio"
        "adm"
        "docker"
        "podman"
        "networkmanager"
        "git"
        "network"
        "wireshark"
        "libvirtd"
        "kvm"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    # create user group until https://github.com/NixOS/nixpkgs/issues/198296 is implemented.
    users.extraGroups.${cfg.username}.name = cfg.username;

    users.users.${cfg.username} = {
      isNormalUser = true;
      shell = cfg.shell;
      home = "/home/${cfg.username}";
      homeMode = "0770";
      createHome = true;
      initialPassword = cfg.initialPassword;
      group = cfg.username;
      extraGroups = cfg.secondary_groups;
      description = cfg.description;
      packages = [];
    };
  };
}
