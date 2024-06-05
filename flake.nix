{
  description = "iHsin NixPkgs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux"];
  in {
    # Nix Helper Functions
    lib = {
      packagesFor = pkgs: import ./pkgs { inherit pkgs; };
    };
    # Nix packages
    packages = forAllSystems (system: self.lib.packagesFor nixpkgs.legacyPackages.${system});

    overlays = {
      default = final: prev: import ./pkgs { inherit final prev; };
    };
    # Nix modules
    nixosModules = {
      default = import ./nixos { ihsinOverlay = self.overlays.default; };
    };

  };
}
