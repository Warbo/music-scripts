{ bash, file, wrap }:

wrap {
  name  = "dodgy_looking_paths";
  file  = ../raw/dodgy_looking_paths.sh;
  paths = [ bash file ];
}
