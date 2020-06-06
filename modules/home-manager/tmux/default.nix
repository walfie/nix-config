{ config, pkgs, lib, ... }:
{
  primary-user.home-manager.home.packages = [ pkgs.tmux ];

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
    if [ -n "$TMUX" ]; then
      # These are needed, otherwise some env vars aren't set
      # https://github.com/LnL7/nix-darwin/pull/174
      unset __ETC_BASHRC_SOURCED
      unset __ETC_ZPROFILE_SOURCED
      unset __ETC_ZSHENV_SOURCED
      unset __ETC_ZSHRC_SOURCED
      unset __NIX_DARWIN_SET_ENVIRONMENT_DONE

      # Same for home-manager
      # https://github.com/rycee/home-manager/issues/183
      unset __HM_SESS_VARS_SOURCED
    fi
  '';
}
