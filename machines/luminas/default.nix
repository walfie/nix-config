{ config, options, pkgs, ... }:

{
  imports = [
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
