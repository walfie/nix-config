{ pkgs, config, ... }:
let
  sources = import ../../nix/sources.nix;
  rust-stable = pkgs.rust-bin.stable."1.56.1".default;
  rust-nightly = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
in
{
  # How to override rust version using mozilla's nix overlay:
  # https://github.com/mozilla/nixpkgs-mozilla/issues/185
  nixpkgs.overlays = [ (import sources.rust-overlay) ];

  home.packages = [
    rust-stable
    pkgs.cargo-edit
    pkgs.cargo-watch
  ];

  home.sessionVariables = {
    # Re-enable incremental compilation in 1.52.1
    # https://blog.rust-lang.org/2021/05/10/Rust-1.52.1.html#what-should-a-rust-programmer-do-in-response
    RUSTC_FORCE_INCREMENTAL = 1;
  };
}
