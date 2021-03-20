{ config, pkgs, lib, ... }:
let
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);
in
{
  home.packages = [
    git-delete-squashed
  ];

  programs.git = {
    enable = true;

    aliases = {
      # Pull upstream/master branch
      up = "!f() { local branch=\${1:-master}; git checkout $branch && git pull \${3:-upstream} $branch; }; f";

      # Squash changes into the previous commit
      fixup = "!git add -u && git commit --fixup=HEAD && git rebase -i --autosquash HEAD~2";

      # git checkout (with fzf)
      cof = "!f() { git for-each-ref --format='%(refname:short)' refs/heads | ${pkgs.fzf}/bin/fzf | xargs git checkout; }; f";
    };

    extraConfig = {
      core = { pager = "less -+F"; };
      pull = { rebase = false; };
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

    ignores = [
      "*.swp"
      "*.swo"
      ".git"
      ".DS_Store"
      "Session.vim"
    ];
  };
}
