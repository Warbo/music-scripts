{ runCommand, shellcheck }:

runCommand "check-music-scripts" {
  scripts = ./.;
  buildInputs = [ shellcheck ];
  LANG = "en_US.UTF-8";
} ''
  set -e

  CODE=0
  while read -r SCRIPT
  do
    echo "Checking '$SCRIPT'" 1>&2

    SHEBANG=$(head -n1 < "$SCRIPT")
    echo "$SHEBANG" | grep '^#!' > /dev/null || {
      echo "No shebang in $SCRIPT"
      CODE=1
    } 1>&2

    echo "$SHEBANG" | grep 'usr/bin/env' > /dev/null ||
    echo "$SHEBANG" | grep '/nix/store'  > /dev/null || {
      echo "$SCRIPT didn't use /usr/bin/env or /nix/store: $SHEBANG"
      CODE=1
    } 1>&2

    shellcheck "$SCRIPT" || CODE=1
  done < <(find "$scripts" -iname '*.sh')
  [[ "$CODE" -eq 0 ]] && mkdir "$out"
''
