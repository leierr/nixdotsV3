{ inputs, lib, config, ... }:
{
  options = {
    home_manager_modules = lib.mkOption {
      default = [];
      description = "configuring home-manager in main config. List of home manager modules";
    };

    system_settings.default_modules.enable = lib.mkOption { type = lib.types.bool; default = true; };

    system_settings.style = import "${inputs.self}/lib/style.nix";
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

  config = {
    system_settings = lib.mkMerge [
      # default enabled modules
      (lib.mkIf config.system_settings.default_modules.enable {
        boot_loader.enable = lib.mkDefault true;
        user_account.enable = lib.mkDefault true;
        locale.enable = lib.mkDefault true;
        network.enable = lib.mkDefault true;
        nixos.enable = lib.mkDefault true;
        nix.enable = lib.mkDefault true;
        privilege_escalation.enable = lib.mkDefault true;
      })

      # automatially enable virt_manager if gui & libvirt are both enabled
      (lib.mkIf (config.system_settings.gui.enable && config.system_settings.virtualization.libvirt.enable) {
        virtualization.libvirt.virt_manager = lib.mkDefault true;
      })
    ];

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
}
