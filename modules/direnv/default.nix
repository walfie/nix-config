{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    # Silence verbose logs
    DIRENV_LOG_FORMAT = "";
  };
}
