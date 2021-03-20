{ config, pkgs, lib, ... }:
let
  sources = import ../../nix/sources.nix;

  # Use pinned nixpkgs instead of channels
  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${sources.nixpkgs}"
  ];
in
{
  # Use pinned nixpkgs as `pkgs` in home-manager config
  # https://rycee.gitlab.io/home-manager/release-notes.html#sec-release-20.09-state-version-changes
  _module.args.pkgsPath = sources.nixpkgs;

  home.sessionVariables = {
    NIX_PATH = nixPath;
  };

  home.packages = [
    pkgs.home-manager
  ];
}
