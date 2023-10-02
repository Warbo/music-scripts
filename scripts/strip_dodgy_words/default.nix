{ bash, replace, mkBin, music-scripts }:

mkBin {
  name = "strip_dodgy_words";
  paths = [ bash music-scripts.move_command replace ];
  file = ./strip_dodgy_words.sh;
}
