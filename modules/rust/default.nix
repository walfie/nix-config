{ pkgs, config, ... }:
let
  rust-stable = pkgs.rust-bin.stable."1.69.0".default.override {
    targets = [ "wasm32-unknown-unknown" ];
  };
  rust-nightly = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
in
{
  home.packages = [
    rust-stable
    pkgs.cargo-watch
  ];

  home.sessionVariables = {
    # Re-enable incremental compilation in 1.52.1
    # https://blog.rust-lang.org/2021/05/10/Rust-1.52.1.html#what-should-a-rust-programmer-do-in-response
    RUSTC_FORCE_INCREMENTAL = 1;

    # https://blog.rust-lang.org/inside-rust/2023/01/30/cargo-sparse-protocol.html
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse";
  };
}
