({
  system ? "x86_64-linux", # default to linux 64bit
  hostName,
  nixpkgs,
  inputs,
  system_state_version,
  configuration ? ("${inputs.self}" + "/hosts/${hostName}/configuration.nix"),
  hardware_configuration ? ("${inputs.self}" + "/hosts/${hostName}/hardware_configuration.nix")
}: 
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ../modules
    configuration
    hardware_configuration
    { system.stateVersion = system_state_version; }
  ];
})
