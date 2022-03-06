{ config, pkgs, lib, ... }:
let
  yarnrc = pkgs.writeTextFile {
    name = "yarnrc";
    text = "disable-self-update-check true";
  };

  yarn = pkgs.symlinkJoin {
    name = "yarn";
    paths = [ pkgs.yarn ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/yarn \
        --add-flags --use-yarnrc \
        --add-flags ${yarnrc}
    '';
  };

  watchman = pkgs.callPackage ./watchman.nix { };
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.nodePackages.pnpm
    yarn

    # This version of watchman seems to hang forever when called, so it's
    # commented out for now. Prefer installing it with the system's preferred
    # package manager (e.g., homebrew on macOS)
    #watchman
  ];
}
