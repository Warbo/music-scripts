{ bash, chromaprint, wrap }:

wrap {
  name  = "gather_acoustids";
  file  = ../raw/gather_acoustids.sh;
  paths = [ bash chromaprint ];
}
