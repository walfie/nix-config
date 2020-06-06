{ config, options, ... }:

let
  # This config file is meant to be used via a symlink, so the paths are
  # relative to the `current-machine` symlink.
  sources = import ../nix/sources.nix;
  overlay = self: super: {
    niv = (import sources.niv {}).niv;
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

in
{
  imports = [
    "${sources.home-manager}/nix-darwin"
    ../modules/darwin
    ../modules/home-manager/bash
    ../modules/home-manager/git
    ../modules/home-manager/neovim
    ../modules/home-manager/tmux
  ];

  networking.hostName = "luminas";
  primary-user = {
    name = "who";

    home-manager.programs.git = {
      userName = "Walfie";
      userEmail = "walfington@gmail.com";
    };
  };

  nix = {
    # You should generally set this to the total number of logical cores in your system.
    # $ sysctl -n hw.ncpu
    maxJobs = 12;
    buildCores = 12;

    nixPath = [
      { darwin = "${sources.nix-darwin}"; }
      { nixpkgs = "${sources.nixpkgs}"; }
    ];
  };

  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.inconsolata ];
  };

  home-manager.users.who = { lib, pkgs, ... }: {
    home.stateVersion = "20.03";
    home.packages = [
      pkgs.doctl
      pkgs.gnused
      pkgs.htop
      pkgs.kubectl
      pkgs.kubectx
      pkgs.ncdu
      pkgs.niv
      pkgs.tealdeer
      pkgs.tmux
      pkgs.wget
    ];
  };

}
