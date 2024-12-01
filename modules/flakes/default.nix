{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = "nix-command flakes";
  };
}
