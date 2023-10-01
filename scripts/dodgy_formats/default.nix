{ bash, wrap }:

wrap {
  name = "dodgy_formats";
  paths = [ bash ];
  file = ./dodgy_formats.sh;
}
