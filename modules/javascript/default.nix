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
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.watchman # For react-native
    pkgs.nodePackages.pnpm
    yarn
  ];
}
