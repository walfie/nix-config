{ config, pkgs, lib, ... }:
let
  watchman = pkgs.callPackage ./watchman.nix { };
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.nodePackages.pnpm
    pkgs.yarn

    # This version of watchman seems to hang forever when called, so it's
    # commented out for now. Prefer installing it with the system's preferred
    # package manager (e.g., homebrew on macOS)
    #watchman
  ];
}
