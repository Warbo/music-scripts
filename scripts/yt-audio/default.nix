{ bash, mkBin, yt-dlp }:

mkBin {
  name = "yt-audio";
  file = ./yt-audio.sh;
  paths = [ yt-dlp ];
}
