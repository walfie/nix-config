{ pkgs, config, ... }:
let
  nvimEnabled = config.primary-user.home-manager.programs.neovim.enable;
in
  with pkgs.lib;
  {
    primary-user.home-manager.home = {
      packages = [
        pkgs.cargo
        pkgs.cargo-edit
        pkgs.cargo-release
        pkgs.cargo-watch
        pkgs.clippy
        pkgs.rustfmt
        pkgs.rust-analyzer
      ];
    };
  }
