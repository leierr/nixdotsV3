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
      user_account.enable = true;
      privilege_escalation.enable = true;
      nixos.enable = true;
      network.enable = true;
      locale.enable = true;
      git.enable = true;
      boot_loader.enable = true;
      shell.enable = true;
      gnupg.enable = true;
    };
  };

  # this file imports all modules. All of them are disabled by default.
  imports = [
    # default enabled
    ./boot_loader
    ./user_account
    ./locale
    ./network
    ./nixos
    ./privilege_escalation
    ./git
    ./shell
    ./gnupg
    ./mlocate

    # the rest
    ./gui
    ./virtualization
    ./bluetooth
  ];
}
