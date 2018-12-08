{ bash, chromaprint, wrap }:

wrap {
  name  = "gather_acoustids";
  file  = ./gather_acoustids.sh;
  paths = [ bash chromaprint ];
}
