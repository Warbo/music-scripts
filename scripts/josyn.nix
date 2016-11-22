{ bash, openssh, psmisc, synergy, writeScript }:

writeScript "josyn" ''
  #!${bash}/bin/bash

  if [[ -z "$JOHOST" ]]
  then
    JOHOST="debian.local"
  fi

  if "${openssh}/bin/ssh" jo@"$JOHOST" true
  then
    echo "Killing synergy client for nixos" 1>&2
    "${openssh}/bin/ssh" jo@"$JOHOST" "./killsyn nixos"

    echo "Killing synergy server" 1>&2
    "${psmisc}/bin/killall" -9 synergys

    "${openssh}/bin/ssh" jo@"$JOHOST" "./synergy" &

    echo "Starting synergy server" 1>&2
    "${synergy}/bin/synergys"
  else
    echo "Can't connect to $JOHOST" 1>&2
    exit 1
  fi
''