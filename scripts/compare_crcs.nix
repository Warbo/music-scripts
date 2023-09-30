{ ffmpeg, python3, wrap }:

wrap {
  name = "compare_crcs";
  file = ../raw + "/compare_crcs.py";
  paths = [ ffmpeg.bin python3 ];
}
