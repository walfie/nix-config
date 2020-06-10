{ pkgs, ... }:
{
  primary-user.home-manager.home = {
    packages = [
      pkgs.cargo
      pkgs.cargo-edit
      pkgs.cargo-release
      pkgs.cargo-watch
      pkgs.clippy
      pkgs.rustfmt
    ];
  };
}
