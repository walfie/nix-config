{ pkgs, ... }:
let
  # Use pinned nixpkgs instead of channels
  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${pkgs.path}"
  ];
in
{
  programs.home-manager.enable = true;

  home.sessionVariables = {
    NIX_PATH = nixPath;
  };
}
