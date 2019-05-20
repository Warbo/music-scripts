{ fdupes, python3, wrap }:

wrap {
  name  = "fix-music";
  file  = ../raw + "/fix-music.py";
  paths = [ fdupes python3 ];
}
