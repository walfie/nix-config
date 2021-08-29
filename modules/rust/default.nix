{ pkgs, config, ... }:
let
  sources = import ../../nix/sources.nix;
  rustStable = pkgs.rustChannelOf {
    channel = "1.54.0";

    # Disable installation of rustdoc (which is very slow).
    # This flag is provided by the code in this PR:
    # https://github.com/mozilla/nixpkgs-mozilla/pull/253
    installDoc = false;
  };
in
{
  # How to override rust version using mozilla's nix overlay:
  # https://github.com/mozilla/nixpkgs-mozilla/issues/185
  nixpkgs.overlays = [ (import sources.nixpkgs-mozilla) ];

  home.packages = [
    rustStable.rust
    pkgs.cargo-edit
    pkgs.cargo-release
    pkgs.cargo-watch
  ];

  home.sessionVariables = {
    # Re-enable incremental compilation in 1.52.1
    # https://blog.rust-lang.org/2021/05/10/Rust-1.52.1.html#what-should-a-rust-programmer-do-in-response
    RUSTC_FORCE_INCREMENTAL = 1;
  };
}
