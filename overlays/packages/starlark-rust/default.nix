{ lib, fetchFromGitHub, makeRustPlatform, rust-bin }:
let
  rustVersion = "1.69.0";

  # Assumes `oxalica/rust-overlay` is active
  # https://github.com/NixOS/nixpkgs/blob/fed0618057e5714b2eb0b88bedbe671ce057a41a/doc/languages-frameworks/rust.section.md#using-rust-nightly-in-a-derivation-with-buildrustpackage-using-rust-nightly-in-a-derivation-with-buildrustpackage
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.${rustVersion}.minimal;
    rustc = rust-bin.stable.${rustVersion}.minimal;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "starlark-rust";
  version = "bb63d4f4fb00999959043003a14373cf077ed68c";
  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "starlark-rust";
    rev = version;
    hash = "sha256-HPJ9ILxsJPh0Ku7Dl43n1T/ZJMOrsjRV/0PGT08hDq4=";
  };

  # https://github.com/NixOS/nixpkgs/blob/fed0618057e5714b2eb0b88bedbe671ce057a41a/doc/languages-frameworks/rust.section.md#buildrustpackage-compiling-rust-applications-with-cargo-compiling-rust-applications-with-cargo
  cargoLock.lockFile = ./Cargo.lock;

  doCheck = false;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A Rust implementation of the Starlark language";
    homepage = "https://github.com/facebookexperimental/starlark-rust";
    changelog = "https://github.com/facebookexperimental/starlark-rust/blob/${version}/CHANGELOG.md";
  };
}
