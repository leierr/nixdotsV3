{
  description = "leiers NixOS dotfiles V3";

  outputs = { nixpkgs, ... }@inputs:
    let
      mkSystem = {
        system ? "x86_64-linux",
        pkgs ? inputs.nixpkgs,
        home_manager ? inputs.home-manager.nixosModules.home-manager,
        host_name,
        system_state_version,
        configuration ? ( ./. + "/hosts/${host_name}/configuration.nix"),
        hardware_configuration ? ( ./. + "/hosts/${host_name}/hardware_configuration.nix")
      }: 
      pkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          hardware_configuration
          ./modules
          home_manager
          { system.stateVersion = system_state_version; }
          { networking.hostName = host_name; }
        ];
      };
    in {
    nixosConfigurations = {
      desktop = mkSystem { host_name = "desktop"; system_state_version = "24.11"; };
      work_laptop = mkSystem { host_name = "work_laptop"; system_state_version = "24.11"; };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    #
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
