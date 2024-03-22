{ inputs, lib, config, ... }:
{
  config = {
    # default enabled modules
    system_settings = lib.mkIf config.system_settings.default_modules {
      boot_loader.enable = lib.mkDefault true;
      user_account.enable = lib.mkDefault true;
      locale.enable = lib.mkDefault true;
      network.enable = lib.mkDefault true;
      nixos.enable = lib.mkDefault true;
      nix.enable = lib.mkDefault true;
      privilege_escalation.enable = lib.mkDefault true;
    };

    # enable together with GUI
    #system_settings.audio.enable = lib.mkIf config.system_settings.gui.enable true;
    #system_settings.pinentry.enable = lib.mkIf config.system_settings.gui.enable true;
    #system_settings.virtualization.libvirt.virt_manager = lib.mkIf (config.system_settings.gui.enable && system_settings.virtualization.libvirt.enable) true;
    #system_settings.gtk.enable = lib.mkIf config.system_settings.gui.enable true;
    #system_settings.qt.enable = lib.mkIf config.system_settings.gui.enable true;

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
  };

  options = {
    home_manager_modules = lib.mkOption {
      default = [];
      description = "configuring home-manager in main config. List of home manager modules";
    };

    system_settings.default_modules = lib.mkOption { type = lib.types.bool; default = true; };

    system_settings.style = import "${inputs.self}/lib/style.nix";
  };

  # this file imports all modules. All of them are disabled by default.
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./boot_loader
    ./user_account
    ./audio
    ./locale
    ./network
    ./nix
    ./nixos
    ./pinentry
    ./virtualization
    ./privilege_escalation
    ./gtk
    ./qt
  ];
}
