{ config, ... }:
with config.xdg;
{
  # Suggestions taken from:
  # https://wiki.archlinux.org/index.php/XDG_Base_Directory
  xdg = {
    enable = true;

    dataFile."less/.keep".text = "";

    configFile."wgetrc".text = "hsts-file = ${cacheHome}/wget-hsts";
    configFile."npm/npmrc".text = ''
      prefix=${dataHome}/npm
      cache=${cacheHome}/npm
      tmp=/tmp/npm
      init-module=${configHome}/npm/config/npm-init.js
    '';
  };

  home.sessionVariables = {
    CARGO_HOME = "${dataHome}/cargo";
    DOCKER_CONFIG = "${configHome}/docker";
    INPUTRC = "${configHome}/readline/inputrc";
    LESSHISTFILE = "${cacheHome}/less/history";
    LESSKEY = "${dataHome}/less/lesskey";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    RLWRAP_HOME = "${dataHome}/rlwrap";
    RUSTUP_HOME = "${dataHome}/rustup";
    WGETRC = "${configHome}/wgetrc";
  };
}
