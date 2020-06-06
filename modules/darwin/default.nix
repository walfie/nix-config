{ config, options, ... }:

let
  sources = import ../../nix/sources.nix;
  overlay = self: super: {
    niv = (import sources.niv {}).niv;
  };
in
{
  imports = [
    "${sources.home-manager}/nix-darwin"
    ./primary-user.nix
  ];

  nix.nixPath = [
    { darwin = "${sources.nix-darwin}"; }
    { nixpkgs = "${sources.nixpkgs}"; }
  ];

  nixpkgs.overlays = [ overlay ];

  # Path to the main config file. To change this value, run:
  # $ darwin-rebuild switch -I darwin-config=$HOME/path/to/configuration.nix
  environment.darwinConfig = "$HOME/nix-config/current-machine/default.nix";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    dock.tilesize = 32;
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
    screencapture.location = "$HOME/Pictures/screenshots/";
  };

  services.nix-daemon.enable = true;

}
