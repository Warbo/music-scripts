{ python3, wrap }:

wrap {
  name  = "fix-music";
  file  = ./. + "/fix-music.py";
  paths = [ python3 ];
}
