{ lib, pkgs, ... }:
let
  rust-stable = pkgs.rust-bin.stable."1.76.0".default.override {
    # Ensure rust-analyzer is aligned with rust version.
    # rust-src is needed for completion for `std` modules.
    extensions = [ "rust-analyzer" "rust-src" ];
    targets = [ "wasm32-unknown-unknown" ];
  };

  rustfmt = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.rustfmt);
  rust-nightly = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.minimal);
  cargo-nightly = pkgs.writeShellScriptBin "cargo-nightly" ''
    export PATH=${rust-nightly}/bin:$PATH
    ${rust-nightly}/bin/cargo $@
  '';
in
{
  home.packages = [
    (lib.hiPrio rustfmt)
    rust-stable
    cargo-nightly
  ];

  home.sessionVariables = {
    # Re-enable incremental compilation in 1.52.1
    # https://blog.rust-lang.org/2021/05/10/Rust-1.52.1.html#what-should-a-rust-programmer-do-in-response
    RUSTC_FORCE_INCREMENTAL = 1;

    # https://blog.rust-lang.org/inside-rust/2023/01/30/cargo-sparse-protocol.html
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse";
  };
}
