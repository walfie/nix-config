# This file contains common settings for macOS systems
{ config, options, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  overlay = self: super: sources;
in
{
  imports = [
    "${sources.home-manager}/nix-darwin"
    ./primary-user.nix
    ../fonts
  ];

  nix.nixPath = [
    { darwin = "${sources.nix-darwin}"; }
    { nixpkgs = "${sources.nixpkgs}"; }
  ];

  nixpkgs.overlays = [ overlay ];

  # Path to the main config file. To change this value, run:
  # $ darwin-rebuild switch -I darwin-config=$HOME/path/to/configuration.nix
  environment.darwinConfig = "$HOME/nix-config/current-machine/default.nix";

  primary-user.home-manager.home.stateVersion = "20.03";

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
