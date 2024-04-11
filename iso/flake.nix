{
  description = "Minimal NixOS installation media";
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      minimal_iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./configuration.nix
        ];
      };
    };
  };
}
