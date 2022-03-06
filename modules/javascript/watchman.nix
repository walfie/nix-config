{ pkgs, stdenv, fetchzip }:

# The version of `watchman` in nixpkgs is very outdated, so this derivation downloads it from GitHub.
let
  version = "v2021.05.10.00";

  meta =
    if stdenv.isDarwin then {
      arch = "macos";
      sha256 = "1y0nybq9v8frpkgnfxfnbqdgmhwgdph503y1xirk6pfasg70h3pq";
    } else {
      arch = "linux";
      sha256 = "1gzpz6mvnsxb2kq1srqw53zkz64dj0fz4ai7w9kc3d7wh4lvr66k";
    };

  url = "https://github.com/facebook/watchman/releases/download/${version}/watchman-${version}-${meta.arch}.zip";
in
stdenv.mkDerivation {
  inherit version;
  name = "watchman";

  src = fetchzip {
    inherit url;
    sha256 = meta.sha256;
  };

  buildInputs = [ pkgs.makeWrapper ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper $src/bin/watchman $out/bin/watchman \
      --argv0 watchman \
      --set DYLD_FALLBACK_LIBRARY_PATH $src/lib
  '';
}

