{ config, options, pkgs, ... }:

{
  imports = [
    ../modules/darwin
    ../modules/home-manager/bash
    ../modules/home-manager/git
    ../modules/home-manager/kitty
    ../modules/home-manager/neovim
    ../modules/home-manager/tmux
    ../modules/kubernetes
    ../modules/rust
  ];

  dock.enable = true;
  networking.hostName = "luminas";
  primary-user = {
    name = "who";

    home-manager.programs.git = {
      userName = "Walfie";
      userEmail = "walfington@gmail.com";
    };

    home-manager.home.packages = [
      pkgs.doctl
      pkgs.gnused
      pkgs.haskellPackages.niv
      pkgs.htop
      pkgs.imagemagick
      pkgs.jq
      pkgs.ncdu
      pkgs.tealdeer
      pkgs.tree
      pkgs.wget

      # JavaScript stuff
      pkgs.nodejs
      pkgs.watchman
      pkgs.yarn
    ];
  };

  nix = {
    # You should generally set this to the total number of logical cores in your system.
    # $ sysctl -n hw.ncpu
    maxJobs = 12;
    buildCores = 12;
  };
}
