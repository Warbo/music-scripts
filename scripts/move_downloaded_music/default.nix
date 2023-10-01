{ attrsToDirs', bash, fetchgit, rsync, warbo-utilities, wrap }:

with { wu = warbo-utilities.warbo-utilities-src; };
wrap {
  name = "album_names_from";
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
  file = ../raw/move_downloaded_music.sh;
}
