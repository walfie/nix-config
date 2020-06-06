{ config, pkgs, lib, ... }:
{
  primary-user.home-manager.home.packages = [
    pkgs.fzf
    pkgs.ripgrep
  ];

  primary-user.home-manager.programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    configure.customRC = lib.fileContents ./vimrc;
    configure.packages.neovim-with-plugins = with pkgs.vimPlugins; {
      start = [
        camelcasemotion
        delimitMate
        emmet-vim
        fzf-vim
        fzfWrapper
        nerdcommenter
        nerdtree
        rainbow
        traces-vim
        vim-abolish
        vim-eunuch
        vim-nerdtree-tabs
        vim-polyglot
        vim-repeat
        vim-sleuth
        vim-surround
        vim-visual-increment
        zenburn

        # TODO:
        # dyng/ctrlsf.vim
        # foosoft/vim-argwrap
        # moll/vim-bbye
        # weynhamz/vim-plugin-minibufexpl
      ];

      opt = [
        vim-scala
      ];
    };
  };
}
