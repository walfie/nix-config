{ pkgs, config, ... }:
let
  sources = import ../../nix/sources.nix;
  rustStable = pkgs.rustChannelOf { channel = "1.50.0"; };
in
{
  # How to override rust version using mozilla's nix overlay:
  # https://github.com/mozilla/nixpkgs-mozilla/issues/185
  nixpkgs.overlays = [ (import sources.nixpkgs-mozilla) ];

  home.packages = [
    # Could just use `rustStable.rust` to include everything, but installing
    # rust docs takes forever
    rustStable.rustc

    pkgs.cargo
    pkgs.cargo-edit
    pkgs.cargo-release
    pkgs.cargo-watch
  ];
}
