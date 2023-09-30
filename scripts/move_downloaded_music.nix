{ attrsToDirs', bash, fetchgit, rsync, wrap }:

with { wu = (import ../helpers.nix { inherit fetchgit; }).warbo-utilities; };
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
