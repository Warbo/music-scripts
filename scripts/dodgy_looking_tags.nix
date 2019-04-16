{ bash, fail, pythonPackages, wrap }:

wrap {
  name  = "dodgy_looking_tags";
  paths = [ bash fail pythonPackages.mutagen ];
  file  = ../raw/dodgy_looking_tags.sh;
}
