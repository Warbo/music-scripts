{ bash, mkBin }:

mkBin {
  name = "dodgy_formats";
  paths = [ bash ];
  file = ./dodgy_formats.sh;
}
