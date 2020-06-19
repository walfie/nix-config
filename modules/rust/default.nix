{ pkgs, config, ... }:
let
  # How to override rust version using mozilla's nix overlay:
  # https://github.com/mozilla/nixpkgs-mozilla/issues/185
  rustStable = pkgs.rustChannelOf {
    channel = "1.44.1";
  };
in
{
  primary-user.home-manager.home = {
    packages = [
      rustStable.rust
      pkgs.cargo-edit
      pkgs.cargo-release
      pkgs.cargo-watch
      pkgs.rust-analyzer
    ];
  };
}
