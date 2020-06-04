{ config, options, ... }:

let
  # Pin nixpkgs version with `sources.nix` file managed by niv
  sources = import ../../nix/sources.nix;
  overlay = self: super: {
    niv = (import sources.niv {}).niv;
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

in
{
  nix = {
    # You should generally set this to the total number of logical cores in your system.
    # $ sysctl -n hw.ncpu
    maxJobs = 4;
    buildCores = 4;

    nixPath = [
      { darwin = "${sources.nix-darwin}"; }
      { nixpkgs = "${sources.nixpkgs}"; }
    ];

  };

  # Path to this file. To change this value, run:
  # $ darwin-rebuild switch -I darwin-config=$HOME/path/to/this/file.nix
  environment.darwinConfig = "$HOME/nix-config/current-machine";

  environment.systemPackages = [
    pkgs.niv
  ];

  services.nix-daemon.enable = true;

  programs.bash.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
