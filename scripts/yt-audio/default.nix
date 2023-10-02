{ bash, mkBin }:

mkBin {
  name = "yt-audio";
  file = ./yt-audio.sh;
}
