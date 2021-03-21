{ config, lib, pkgs, ... }:
{
  imports = [
    ./dock
  ];

  home.activation.setDefaults =
    lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.fileContents ./set-defaults.sh);

  home.sessionVariables = {
    BASH_SILENCE_DEPRECATION_WARNING = "1";
    HOMEBREW_NO_ANALYTICS = "1";
  };
}
