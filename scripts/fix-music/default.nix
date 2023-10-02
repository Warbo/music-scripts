{ python3, mkBin }:

mkBin {
  name = "fix-music";
  file = ./fix-music.py;
  paths = [ python3 ];
}
