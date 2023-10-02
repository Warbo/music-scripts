{ attrsToDirs', bash, fetchgit, rsync, warbo-utilities, mkBin }:

with { wu = warbo-utilities.warbo-utilities-src; };
mkBin {
  name = "move_downloaded_music";
  paths = [
    bash
    rsync
    # Referencing these scripts directly avoids dragging in loads of deps
    (attrsToDirs' "copy-utils" {
      bin = {
        copy = "${wu}/system/copy";
        keep_trying = "${wu}/system/keep_trying";
      };
    })
  ];
  file = ./move_downloaded_music.sh;
}
