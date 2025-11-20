{inputs, ...}: {
  commonModules = [
    inputs.stylix.nixosModules.stylix
    inputs.cachyos.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.aagl.nixosModules.default
    ../configuration.nix
  ];
}
