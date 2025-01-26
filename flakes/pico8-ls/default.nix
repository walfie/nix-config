{ config, dream2nix, pico8-ls, ... }:
let
  name = "pico8-ls";
  version = "0.5.7";
  deps = config.deps;
in
{
  inherit name version;

  imports = [
    dream2nix.modules.dream2nix.nodejs-package-lock-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  deps = { nixpkgs, ... }: {
    inherit (nixpkgs) esbuild nodejs_20;
  };

  mkDerivation = {
    src = pico8-ls;
    buildInputs = [ deps.esbuild ];
    installPhase = ''
      mkdir -p $out/bin

      cat > $out/bin/${name} << EOF
      #!/bin/sh
      ${deps.nodejs_20}/bin/node $out/lib/node_modules/${name}/server/out-min/main.js \$@
      EOF

      chmod +x $out/bin/${name}
    '';
  };

  nodejs-granular-v3 = {
    buildScript = "npm run esbuild-server";
  };

  nodejs-package-lock-v3 = {
    packageLockFile = "${config.mkDerivation.src}/server/package-lock.json";
  };
}
