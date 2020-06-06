{ config, pkgs, lib, ... }:
{
  primary-user.home-manager.programs.git = {
    enable = true;

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

    ignores = [
      "*.swp"
      "*.swo"
      ".DS_Store"
      "Session.vim"
    ];
  };
}
