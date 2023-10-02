{ bash, mkBin }:

mkBin {
  name = "stdio-find_dupe_files";
  file = ./stdio-find_dupe_files.sh;
}
