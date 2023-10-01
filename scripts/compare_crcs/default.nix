{ ffmpeg, python3, wrap }:

wrap {
  name = "compare_crcs";
  file = ./compare_crcs.py;
  paths = [ ffmpeg.bin python3 ];
}
