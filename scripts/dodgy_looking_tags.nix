{ bash, fail, python3, wrap }:

wrap {
  name = "dodgy_looking_tags";
  paths = [ bash fail (python3.withPackages (p: [ p.mutagen ])) ];
  file = ../raw/dodgy_looking_tags.sh;
}
