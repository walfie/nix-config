{ pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.inconsolata ];
  };
}
