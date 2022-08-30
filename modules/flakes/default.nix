{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
}

