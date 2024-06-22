{
  description = "leiers NixOS dotfiles V3";

  outputs = { nixpkgs, ... }@inputs:
    let
      mkSystem = {
        system ? "x86_64-linux",
        pkgs ? inputs.nixpkgs,
        home_manager ? inputs.home-manager,
        host_name,
        system_state_version ? (inputs.nixpkgs.lib.versions.majorMinor inputs.nixpkgs.lib.version),
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
      desktop = mkSystem { host_name = "desktop"; };
      work_laptop = mkSystem { host_name = "work_laptop"; };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    #
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #
    ags = { url = "github:Aylur/ags"; inputs.nixpkgs.follows = "nixpkgs"; };
    hyprland = { url = "github:hyprwm/Hyprland"; inputs.nixpkgs.follows = "nixpkgs"; };
    hyprpaper = { url = "github:hyprwm/hyprpaper"; inputs.nixpkgs.follows = "nixpkgs"; };
    hypridle = { url = "github:hyprwm/hypridle"; inputs.nixpkgs.follows = "nixpkgs"; };
    hyprlock = { url = "github:hyprwm/Hyprlock"; inputs.nixpkgs.follows = "nixpkgs"; };
  };
}
