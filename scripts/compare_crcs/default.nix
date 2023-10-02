{ ffmpeg, python3, mkBin }:

mkBin {
  name = "compare_crcs";
  file = ./compare_crcs.py;
  paths = [ ffmpeg.bin python3 ];
}
