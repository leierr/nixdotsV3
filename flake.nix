{
  description = "leiers NixOS dotfiles V3";

  outputs = { nixpkgs, ... }@inputs:
    let
      mkSystem = {
        system ? "x86_64-linux", pkgs ? inputs.nixpkgs, host_name, system_state_version,
        configuration ? ( ./. + "/hosts/${host_name}/configuration.nix"),
        hardware_configuration ? ( ./. + "/hosts/${host_name}/hardware_configuration.nix")
        home_manager_module ? inputs.home-manager.nixosModules.home-manager # defaults to stable.
      }: 
      pkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          hardware_configuration
          ./modules
          home_manager_module
          { system.stateVersion = system_state_version; }
          { networking.hostName = host_name; }
        ];
      };
    in {
    nixosConfigurations =  {
      desktop = mkSystem { host_name = "desktop"; system_state_version = "23.11"; };
      workmachine = mkSystem { host_name = "workmachine"; system_state_version = "23.11"; };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    #
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #
    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    #
    ags = { url = "github:Aylur/ags"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    hyprland = { url = "github:hyprwm/Hyprland"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    hyprpaper = { url = "github:hyprwm/hyprpaper"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    hypridle = { url = "github:hyprwm/hypridle"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    hyprlock = { url = "github:hyprwm/Hyprlock"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
  };
}
