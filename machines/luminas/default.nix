{ config, options, pkgs, ... }:
{
  imports = [
    ../../modules/bash
    ../../modules/direnv
    ../../modules/flakes
    ../../modules/git
    ../../modules/home-manager
    ../../modules/javascript
    ../../modules/kitty
    ../../modules/kubernetes
    ../../modules/macos
    ../../modules/neovim
    ../../modules/rust
    ../../modules/tmux
    ../../modules/xdg
    ../../modules/zsh
  ];

  macos-dock.enable = true;

  home = {
    username = "who";
    homeDirectory = "/Users/who";
    stateVersion = "21.05";

    sessionVariables = {
      HOME_MANAGER_CONFIG = "/Users/who/nix-config/current-machine";
    };
  };

  programs.git = {
    userName = "Walfie";
    userEmail = "walfington@gmail.com";
  };

  home.packages = [
    pkgs.coreutils # Use GNU versions of `ls`, etc
    pkgs.doctl
    pkgs.ffmpeg
    pkgs.gnused
    pkgs.gron
    pkgs.htop
    pkgs.imagemagick
    pkgs.jq
    pkgs.ncdu
    pkgs.niv
    pkgs.nixpkgs-fmt
    pkgs.rename
    pkgs.tealdeer
    pkgs.telnet
    pkgs.tree
    pkgs.wget
  ];
}
