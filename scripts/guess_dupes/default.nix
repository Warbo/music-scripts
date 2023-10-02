{ mkBin, music-scripts }:

mkBin {
  name = "guess_dupes";
  file = ./guess_dupes.sh;
  paths = [ music-scripts.strip_name ];
}
