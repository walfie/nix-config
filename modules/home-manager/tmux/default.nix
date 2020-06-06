{ config, pkgs, lib, ... }:
{
  primary-user.home-manager.programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    shortcut = "a";
    secureSocket = false;
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.sensible
      tmuxPlugins.yank
    ];

    extraConfig = lib.fileContents ./tmux.conf;
  };

  environment.interactiveShellInit = ''
    # This is needed, otherwise some env vars aren't set in tmux
    # https://github.com/LnL7/nix-darwin/pull/174
    unset __NIX_DARWIN_SET_ENVIRONMENT_DONE
  '';
}
