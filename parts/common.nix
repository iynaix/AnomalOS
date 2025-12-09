{inputs, ...}: {
  commonModules = [
    inputs.stylix.nixosModules.stylix
    inputs.agenix.nixosModules.default
    inputs.aagl.nixosModules.default
    ../configuration.nix
  ];
}
