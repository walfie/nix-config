{ config, lib, pkgs, ... }:
{
  imports = [
    ./dock
  ];

  home.activation.setDefaults =
    lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.fileContents ./set-defaults.sh);
}
