{ emptyAudio, fail, runCommand, scripts }: {
  canSetTitle = runCommand "can-set-title" {
    inherit (emptyAudio) mp3;
    __noChroot = true;
    buildInputs = [ fail scripts ];
  } ''
    cp -L "$mp3" ./file.mp3
    chmod +w     ./file.mp3

    WANT=MyTitle
    set_tag title "$WANT" ./file.mp3

    GOT=$(get_tag title ./file.mp3)

    echo "WANT: '$WANT', GOT: '$GOT'" 1>&2
    [[ "x$WANT" = "x$GOT" ]] || fail "Expected '$WANT', got '$GOT'"
    mkdir "$out"
  '';
}
