{ libav, python, wrap }:

wrap {
  name  = "compare_crcs";
  file  = ../raw + "/compare_crcs.py";
  paths = [ libav.bin python ];
}
