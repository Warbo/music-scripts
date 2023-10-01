{ python3, wrap }:

wrap {
  name = "set_tag";
  paths = [ (python3.withPackages (p: [ p.mutagen ])) ];
  file = ./set_tag.py;
}
