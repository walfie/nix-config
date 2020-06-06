{ config, options, ... }:

let
  # This config file is meant to be used via a symlink, so the paths are
  # relative to the `current-machine` symlink.
  sources = import ../nix/sources.nix;
  overlay = self: super: {
    niv = (import sources.niv {}).niv;
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

in
{
  imports = [
    "${sources.home-manager}/nix-darwin"
  ];

  # Path to this file. To change this value, run:
  # $ darwin-rebuild switch -I darwin-config=$HOME/path/to/this/file.nix
  environment = {
    darwinConfig = "$HOME/nix-config/current-machine/default.nix";
    shells = [ pkgs.bashInteractive_5 ];

    interactiveShellInit = ''
      # This is needed, otherwise some env vars aren't set in tmux
      # https://github.com/LnL7/nix-darwin/pull/174
      unset __NIX_DARWIN_SET_ENVIRONMENT_DONE
    '';
  };

  nix = {
    # You should generally set this to the total number of logical cores in your system.
    # $ sysctl -n hw.ncpu
    maxJobs = 12;
    buildCores = 12;

    nixPath = [
      { darwin = "${sources.nix-darwin}"; }
      { nixpkgs = "${sources.nixpkgs}"; }
    ];

  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    dock.tilesize = 32;
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
    screencapture.location = "$HOME/Pictures/screenshots/";
  };

  services.nix-daemon.enable = true;

  networking.hostName = "luminas";

  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.inconsolata ];
  };

  users.users.who = {
    home = "/Users/who";
    shell = pkgs.bashInteractive_5;
  };

  home-manager.users.who = { lib, pkgs, ... }: {
    home.stateVersion = "20.03";
    home.packages = [
      pkgs.bash-completion
      pkgs.bashInteractive_5
      pkgs.doctl
      pkgs.fzf
      pkgs.gnused
      pkgs.htop
      pkgs.kubectl
      pkgs.kubectx
      pkgs.ncdu
      pkgs.niv
      pkgs.ripgrep
      pkgs.tealdeer
      pkgs.tmux
      pkgs.wget
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      configure = {
        packages.neovim-with-plugins = with pkgs.vimPlugins; {
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

        # TODO: Put this in separate file
        customRC = ''
          let g:polyglot_disabled = ['scala']
          autocmd FileType scala :packadd vim-scala

          " Write to a file as root
          command! W :execute ':silent w !sudo tee % >/dev/null' | :edit!
          command! Wq :execute ':W' | :q

          " Strip all trailing whitespace
          command! Clean :execute ':%s/\s\+$//'

          " Misc settings
          syntax on
          set autoindent
          set backspace=2
          set expandtab
          set hidden
          set lazyredraw
          set linebreak
          set list
          set listchars=tab:>\ ,trail:.
          set noincsearch
          set nomodeline
          set number
          set sessionoptions=buffers
          set shiftwidth=2
          set shortmess-=S
          set showcmd
          set showmode
          set synmaxcol=2048
          set tabstop=2
          set virtualedit=block

          " Status line (file, line, total lines, vcolumn, percent)
          set laststatus=2
          set statusline=%F%=%l/%L,%v\ %p%%

          " Disable error sounds
          set visualbell
          set noerrorbells

          " Persistent undo
          set undodir=~/.vim/undodir
          set undofile
          set undolevels=1000
          set undoreload=10000

          " Searching
          set ignorecase
          set smartcase
          set hlsearch

          " Don't change cursor shape in neovim insert mode
          " https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-shape-in-the-terminal
          :set guicursor=
          :autocmd OptionSet guicursor noautocmd set guicursor=

          "FormatOptions to disable autocomments
          autocmd FileType * setlocal formatoptions-=c fo-=o fo-=r fo+=l
          autocmd FileType minibufexpl setlocal statusline=%#Normal#
          autocmd FileType crontab setlocal nobackup nowritebackup

          " Disable SQL dynamic completion
          let g:omni_sql_no_default_maps = 1

          " Colors
          set t_Co=256
          let g:zenburn_high_Contrast=1
          colorscheme zenburn
          highlight Visual term=reverse cterm=reverse
          highlight MatchParen cterm=bold ctermbg=none ctermfg=magenta
          highlight TrailingWhitespace ctermfg=darkgreen
          match TrailingWhiteSpace /\s\+$/

          "Highlight right margin
          if exists('+colorcolumn')
            set colorcolumn=72,80,90,100
            highlight ColorColumn ctermbg=235
          endif

          " Copy to clipboard
          " https://www.reddit.com/r/neovim/comments/3fricd/easiest_way_to_copy_from_neovim_to_system/ctrru3b/
          vnoremap <leader>y "+y
          nnoremap <leader>Y "+yg_
          nnoremap <leader>y "+y

          " Paste from clipboard
          nnoremap <leader>p "+p
          nnoremap <leader>P "+P
          vnoremap <leader>p "+p
          vnoremap <leader>P "+P

          " Delete buffer
          map <silent> <Leader>q :Bdelete<CR>
          map <silent> <Leader>Q :Bdelete!<CR>

          " Switch between buffers
          nnoremap <silent> <C-t> :enew<CR>
          nnoremap <silent> <C-l> :bnext<CR>
          nnoremap <silent> <C-h> :bprevious<CR>

          " Clear highlighted text
          nnoremap <silent> <CR> :nohlsearch<CR><CR>

          " Ctrl+P for fuzzy finder
          let g:fzf_command_prefix = 'Fzf'
          map <silent> <C-p> <Esc>:FzfFiles<CR>
          map <silent> <Leader>b <Esc>:FzfBuffers<CR>
          map <silent> <Leader>l <Esc>:FzfLines<CR>
          "\a for... well, it used to be `ag` but now it's `rg`
          map <silent> <Leader>a <Esc>:FzfRg<CR>
          "\d for definition
          map <silent> <Leader>d <Esc>:FzfRg (class\|trait\|object\|struct\|enum)<CR>

          " Ctrl+l to autocomplete from Rg search
          imap <C-x><C-l> <Plug>(fzf-complete-line)

          function! RgCompleteCommand(args)
            return "rg ^ --color never --no-filename --no-line-number ".a:args." . | awk '!seen[$0]++'"
          endfunction

          inoremap <expr> <C-l> fzf#vim#complete(fzf#wrap({
          \ 'prefix': '^.*$',
          \ 'source': function('RgCompleteCommand'),
          \ 'options': '--ansi'
          \}))

          " CtrlSF shortcut (ack/ag plugin)
          map <Leader>f <Plug>CtrlSFPrompt

          " JSON conceal off
          let g:vim_json_syntax_conceal = 0

          " NERDTree plugin
          map <Leader>n <Plug>NERDTreeTabsToggle<CR>
          let NERDTreeShowLineNumbers=1
          let NERDTreeMinimalUI=1
          let NERDTreeIgnore = ['\.class$', '\.jar$', '\.bk$']
          let NERDTreeShowHidden=1

          " ArgWrap
          nnoremap <silent> <Leader>w :ArgWrap<CR>

          " Rainbow parentheses
          let g:rainbow_active = 1
          let g:rainbow_conf = {
          \  'ctermfgs': [
          \    'darkred', 'darkgreen', 'darkmagenta', 'darkcyan', 'red',
          \    'yellow', 'green', 'darkyellow', 'magenta', 'cyan', 'darkyellow'
          \  ]
          \}

          " DelimitMate
          let delimitMate_quotes = '" `'
        '';

      };
    };

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      shortcut = "a";
      plugins = with pkgs; [
        tmuxPlugins.pain-control
        tmuxPlugins.sensible
        tmuxPlugins.yank
      ];

      extraConfig = ''
        set-option -ga update-environment ' NIX_PATH'
        set -g renumber-windows on

        # Window number, program name, active (or not)
        set -g set-titles-string '#H:#S.#I.#P #W #T'

        # Highlight active window
        setw -g window-status-current-style bg=white

        # Lowers delay time between prefix key and other keys
        set -sg escape-time 0

        # Ctrl-a twice to send Ctrl-a to the application
        bind a send-prefix
        bind C-a send-prefix

        # Zenburn color scheme
        setw -g clock-mode-colour colour117
        setw -g mode-style fg=colour117,bg=colour238,bold
        set -g status-style fg=colour248,bg=colour235
        setw -g window-status-current-style fg=colour223,bg=colour237,bold
        set -g message-style fg=colour117,bg=colour235,bold
        set -g pane-active-border-style fg=colour245
        set -g pane-border-style fg=colour235
      '';
    };

    programs.git = {
      userName = "Walfie";
      userEmail = "walfington@gmail.com";

      aliases = {
        up = "!f() { local branch=\${1:-master}; git checkout $branch && git pull \${3:-upstream} $branch; }; f";
        fixup = "!git add -A && git commit --fixup=HEAD && git rebase -i --autosquash HEAD~2";
      };

      extraConfig = {
        core = { pager = "less -+F"; };
        push = { default = "current"; };
        rebase = { autosquash = true; };
        rerere = { enabled = true; };
        color = {
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
        };
      };

      enable = true;
      ignores = [
        "*.swp"
        "*.swo"
        ".DS_Store"
        "Session.vim"
      ];
    };

    programs.bash = {
      enable = true;
      enableAutojump = true;
      historyControl = [ "ignoredups" ];
      historySize = -1;
      historyFileSize = -1;
      initExtra = ''
        PROMPT_COMMAND="history -a";
        RLWRAP_HOME="$HOME/.local/share/rlwrap/";
        EDITOR="nvim";

        LS_COLORS="di=38;5;108:fi=00:ln=38;5;116:ex=38;5;186";
        COLOR1="\[$(tput setaf 187)\]";
        COLOR2="\[$(tput setaf 174)\]";
        RESET="\[$(tput sgr 0)\]";
        BOLD="\[$(tput bold)\]";
        PS1="\t $BOLD$COLOR1\u@\h:$COLOR2\W\\$ $RESET";
      '';

      shellAliases = {
        ".." = "cd ..";
        grep = "grep --color -I";
        ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
        ll = "ls -l";
        ls = "ls -G";
        path = "echo -e $${PATH//:/\\n}";
        z = "j";
      };

      sessionVariables = {};
    };
  };

}
