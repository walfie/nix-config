# This file contains common settings for macOS systems
{ config, lib, options, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  unstable = import sources.nixpkgs-unstable {};

  # TODO: Add overlays file
  overlays = [
    # mozilla
    (import sources.nixpkgs-mozilla)

    # vim
    (
      self: super: {
        inherit (unstable) neovim neovim-unwrapped wrapNeovim vimPlugins;
      }
    )

    # rust
    (
      self: super: {
        inherit (unstable) rust-analyzer;
      }
    )
  ];

in
rec {
  imports = [
    "${sources.home-manager}/nix-darwin"
    ./dock
    ./primary-user.nix
    ../home-manager/xdg
  ];

  nix.nixPath = [
    { darwin = "${sources.nix-darwin}"; }
    { nixpkgs = "${sources.nixpkgs}"; }
  ];

  nixpkgs.overlays = overlays;

  # Path to the main config file. To change this value, run:
  # $ darwin-rebuild switch -I darwin-config=$HOME/path/to/configuration.nix
  environment.darwinConfig = "$HOME/nix-config/current-machine/default.nix";

  primary-user.home = "/Users/${config.primary-user.name}";
  primary-user.home-manager.home = {
    stateVersion = "20.03";
    sessionVariables = {
      HOMEBREW_NO_ANALYTICS = "1";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.activationScripts.setDefaults = {
    enable = true;
    source = ./set-defaults.sh;
  };

  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };

    dock.tilesize = 42;
    screencapture.location = "${primary-user.home}/Pictures/screenshots/";
  };

  services.nix-daemon.enable = true;
}
