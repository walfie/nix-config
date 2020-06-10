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
      pkgs.htop
      pkgs.ncdu
      pkgs.haskellPackages.niv
      pkgs.tealdeer
      pkgs.wget
    ];
  };

  nix = {
    # You should generally set this to the total number of logical cores in your system.
    # $ sysctl -n hw.ncpu
    maxJobs = 12;
    buildCores = 12;
  };
}
