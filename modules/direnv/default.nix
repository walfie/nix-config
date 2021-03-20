{ config, pkgs, lib, ... }:
{
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  home.sessionVariables = {
    # Silence verbose logs
    DIRENV_LOG_FORMAT = "";
  };
}
