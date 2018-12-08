{ libav, python, wrap }:

wrap {
  name  = "compare_crcs";
  file  = ./compare_crcs.py;
  paths = [ libav.bin python ];
}
