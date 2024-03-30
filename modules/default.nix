{ inputs, lib, config, ... }:
{
  options = {
    home_manager_modules = lib.mkOption {
      default = [];
      description = "configuring home-manager in main config. List of home manager modules";
    };

    system_settings.default_modules.enable = lib.mkEnableOption "";
  };

  config = {
    # home-manager setup
    home-manager = lib.mkIf config.system_settings.user_account.enable {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };
      users.${config.system_settings.user_account.username} = {
        imports = config.home_manager_modules;
        home.stateVersion = "${config.system.stateVersion}";
      };
    };

    # default enabled
    system_settings = lib.mkIf config.system_settings.default_modules.enable {
      user_account.enable = lib.mkDefault true;
      nix.enable = lib.mkDefault true;
      nixos.enable = lib.mkDefault true;
      network.enable = lib.mkDefault true;
      locale.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      boot_loader.enable = lib.mkDefault true;
    };
  };

  # this file imports all modules. All of them are disabled by default.
  imports = [
    # home-manager
    inputs.home-manager.nixosModules.home-manager

    # default enabled
    ./boot_loader
    ./user_account
    ./locale
    ./network
    ./nix
    ./nixos
    ./privilege_escalation

    # the rest
    ./gui
    ./virtualization
    ./git
  ];
}
