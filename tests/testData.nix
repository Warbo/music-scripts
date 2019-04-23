{ attrsToDirs', die, ffmpeg, foldAttrs', lib, nothing, runCommand,
  sanitiseName, scripts, writeScript }:

with builtins;
with lib;
rec {
  renderAlbum = artist: { id, name, year, ... }:
    with { url = "https://example.com/albums/${artist}/${name}/${id}"; };
    ''
      <tr>
        <td>
          <a href="${url}" class="album">${name}</a>
        </td>
        <td class="album">Full-length</td>
        <td class="album">${year}</td>
        <td>
          <a href="${url}/">1 (100%)</a>
        </td>
      </tr>
    '';

  renderAlbums = artist: albums: writeScript "albums-of-${sanitiseName artist}" ''
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Type</th>
          <th>Year</th>
          <th>Reviews</th>
        </tr>
      </thead>
      <tbody>
        ${concatStringsSep "\n" (map (renderAlbum artist) albums)}
      </tbody>
    </table>
  '';

  testArtists = {
    A = {
      Artist1 = {
        nowhere = {
          albums  = [
            {
              id     = "11";
              name   = "Album1";
              year   = "2001";
            }
            {
              id   = "12";
              name = "Album2";
              year = "2002";
            }
          ];
        };
      };
      Artist2 = {
        UK = {
          albums  = [
            {
              id   = "21";
              name = "Album One";
              year = "1991";
            }
          ];
        };
      };
    };
    D = {
      DuplicatedArtist = {
        Nor = {
          albums  = [
            {
              id         = "111";
              name       = "From Norway One";
              year       = "1981";
              audioFiles = {
                "01 A Song.mp3" = { format = "mp3"; tags = {}; };
              };
            }
            {
              id   = "112";
              name = "From Norway Two";
              year = "1982";
            }
          ];
        };
        Swe = {
          albums  = [
            {
              id         = "121";
              name       = "From Sweden One";
              year       = "1991";
              audioFiles = {
                "01 A Song.mp3" = { format = "mp3"; tags = {}; };
              };
            }
            {
              id   = "112";
              name = "From Sweden Two";
              year = "1992";
            }
          ];
        };
      };
    };
    H = {
      "Has Discs" = {
        nowhere = {
          albums = [
            {
              id   = "123";
              name = "An Album (Disc 1)";
              year = "2001";
            }
            {
              id   = "124";
              name = "An Album (Disc 2)";
              year = "2011";
            }
          ];
        };
      };
    };
    P = {
      "Performer 3" = {
        nowhere = {
          albums  = [
            {
              id         = "31";
              name       = "First Album";
              year       = "2011";
              audioFiles = {
                "01 A Song.mp3" = { format = "mp3"; tags = {}; };
              };
            }
            {
              id   = "32";
              name = "Second Album";
              year = "2012";
            }
          ];
        };
      };
    };
  };

  addCountry = artist: country: artist + (if country == "nowhere"
                                             then ""
                                             else " (${country})");

  addCountryToName =
    with {
      go = artist: mapAttrs' (country: value: {
                               inherit value;
                               name = addCountry artist country;
                             });

      test = go "DuplicatedArtist" testArtists.D.DuplicatedArtist;

      want = "DuplicatedArtist (Nor)";
    };
    assert test ? want || die {
      inherit want;
      error = "addCountryToName didn't make expected test output";
      got   = attrNames test;
    };
    go;

  testMusicFiles =
    with rec {
      entryToFiles = data: fold (album: result: result // {
                                  "${album.name}" = mapAttrs (_: mkAudioFile)
                                                             (album.audioFiles
                                                              or {});
                                })
                                (data.otherFiles or {})
                                data.albums;

      entriesToDirs = artist: foldAttrs' (country: data: result: result // {
                                           "${addCountry artist country}" =
                                             entryToFiles data;
                                         })
                                         {};

      dir = {
        Music = {
          Commercial =
            mapAttrs (init: foldAttrs' (artist: entries: result:
                                         result // entriesToDirs artist entries)
                                       {})
                     testArtists;
        };
      };

      testDirs = path: namesAt path testMusicFiles;
    };
    assert isAttrs (dir.Music.Commercial.D."DuplicatedArtist (Nor)" or 1) || die {
      error = "Test data doesn't contain country-coded artist directory";
      want  = "Music/Commercial/D/DuplicatedArtist (Nor)";
    };
    dir;

  # Creates 'foo.albums' cache files, used by commands which look up albums
  albumCache =
    with {
      flattenArtistName = artist: entries:
        fold (country: result:
               with {
                 cnt = if country == "nowhere"
                          then ""
                          else country;
               };
               result // {
                 "${artist}_${cnt}.albums" =
                   renderAlbums artist
                                (getAttr "albums" (getAttr country entries));
               })
             {}
             (attrNames entries);

      mergeValues = attrs: fold (x: y: y // x)
                                {}
                                (attrValues attrs);
    };
    {
      ".artist_name_cache" = mapAttrs (_: names: mergeValues
                                                   (mapAttrs flattenArtistName
                                                             names))
                                      testArtists;
    };

  # A recreation of the relevant directories in Shared, containing caches and
  # Music/Commercial.
  testData = attrsToDirs' "music-script-test-data"
                          (testMusicFiles // albumCache);

  # Silent audio files of various formats. We usually want to add tags to these,
  # rather than keeping them completely raw.
  emptyAudio = {
    mp3 = runCommand "empty.mp3" { buildInputs = [ ffmpeg ]; } ''
      ffmpeg -ar 48000 -t 60 -f s16le -acodec pcm_s16le -ac 2 -i /dev/zero \
             -acodec libmp3lame -aq 4 "$out"
    '';
  };

  tsvString = data: concatStringsSep "\n" (map (concatStringsSep "\t") data);

  tsvFile = name: data: writeScript "${name}.tsv" (tsvString data);

  attrsToTsv = foldAttrs' (name: val: result: result ++ [ name val ]) [];

  mkAudioFile = { format, tags }: runCommand "audio-file.${format}"
    {
      buildInputs = [ scripts ];
      untagged    = if hasAttr format emptyAudio
                       then getAttr format emptyAudio
                       else die {
                         inherit format;
                         error     = "Format not supported";
                         supported = attrNames emptyAudio;
                       };
    }
    ''
      cp "$untagged" "$out"
      while read -r LINE
      do
        TAG=$(echo "$LINE" | cut -f1)
        VAL=$(echo "$LINE" | cut -f2-)
        set_tag "$TAG" "$VAL" "$out"
      done < "${tsvFile "tags" (attrsToTsv tags)}"
    '';
}
