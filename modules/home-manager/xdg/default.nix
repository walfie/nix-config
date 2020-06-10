{ config, ... }:
{
  # Suggestions taken from:
  # https://wiki.archlinux.org/index.php/XDG_Base_Directory
  primary-user.home-manager.xdg = {
    enable = true;

    dataFile."wgetrc".text = "hsts-file = ${config.primary-user.home}/wget-hsts";
    dataFile."less/.keep".text = "";
    dataFile."vim/undo/.keep".text = "";
    dataFile."vim/swap/.keep".text = "";
    dataFile."vim/backup/.keep".text = "";

    configFile."npm/npmrc".text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      tmp=''${XDG_RUNTIME_DIR}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    '';
  };

  primary-user.home-manager.home.sessionVariables = {
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
    LESSHISTFILE = "$XDG_DATA_HOME/less/history";
    LESSKEY = "$XDG_DATA_HOME/less/lesskey";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    RLWRAP_HOME = "$XDG_DATA_HOME/rlwrap";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };
}
