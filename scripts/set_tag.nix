{ python3, wrap }:

wrap {
  name = "set_tag";
  paths = [ (python3.withPackages (p: [ p.mutagen ])) ];
  file = ../raw/set_tag.py;
}
