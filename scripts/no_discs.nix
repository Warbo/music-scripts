{ bash, convmv, wrap }:

wrap {
  name  = "no_discs";
  file  = ../raw/no_discs.sh;
  paths = [ bash convmv ];
}
