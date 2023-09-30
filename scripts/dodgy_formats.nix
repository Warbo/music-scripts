{ bash, wrap }:

wrap {
  name = "dodgy_formats";
  paths = [ bash ];
  file = ../raw/dodgy_formats.sh;
}
