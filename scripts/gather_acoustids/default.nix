{ bash, chromaprint, mkBin }:

mkBin {
  name = "gather_acoustids";
  file = ./gather_acoustids.sh;
  paths = [ bash chromaprint ];
}
