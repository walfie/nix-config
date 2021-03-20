{ config, options, pkgs, ... }:
{
  imports = [
    ../../modules/bash
    ../../modules/git
    ../../modules/home-manager
    ../../modules/kitty
    ../../modules/kubernetes
    ../../modules/macos
    ../../modules/neovim
    ../../modules/rust
    ../../modules/tmux
    ../../modules/xdg
  ];

  macos-dock.enable = true;

  home = {
    username = "who";
    homeDirectory = "/Users/who";
    stateVersion = "20.09";

    sessionVariables = {
      HOME_MANAGER_CONFIG = "/Users/who/nix-config/current-machine";
    };
  };

  programs.git = {
    userName = "Walfie";
    userEmail = "walfington@gmail.com";
  };

  home.packages = [
    pkgs.doctl
    pkgs.ffmpeg
    pkgs.gnused
    pkgs.htop
    pkgs.imagemagick
    pkgs.jq
    pkgs.ncdu
    pkgs.niv
    pkgs.tealdeer
    pkgs.tree
    pkgs.wget

    # JavaScript stuff
    pkgs.nodejs
    pkgs.watchman
    pkgs.yarn
  ];
}
