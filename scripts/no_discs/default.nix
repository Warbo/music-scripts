{ bash, convmv, wrap }:

wrap {
  name = "no_discs";
  file = ./no_discs.sh;
  paths = [ bash convmv ];
}
