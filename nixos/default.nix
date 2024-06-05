{ ihsinOverlay }:

{
  imports = import ./module-list.nix;

  nixpkgs.overlays = [ ihsinOverlay ];
}