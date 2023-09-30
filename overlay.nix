self: super:

with builtins;
with self.lib;
with {
  process = f:
    if hasSuffix ".nix" f then
      self.callPackage (./scripts + "/${f}") { }
    else
      "${./scripts}/${f}";

  check = mapAttrs (name: script:
    self.runCommand "check-${name}" {
      inherit script;
      buildInputs = [ self.fail self.shellcheck ];
      LANG = "en_US.UTF-8";
    } ''
      set -e

      # Unwrap until we get to the real implementation
      while grep "extraFlagsArray" < "$script" > /dev/null
      do
        script=$(grep '^exec' < "$script" | cut -d ' ' -f2 |
                                            tr -d '"')
      done
      echo "Checking '$script'" 1>&2

      SHEBANG=$(head -n1 < "$script")
      echo "$SHEBANG" | grep '^#!' > /dev/null || {
        # Binaries, etc.
        mkdir "$out"
        exit 0
      }

      echo "$SHEBANG" | grep 'usr/bin/env' > /dev/null ||
      echo "$SHEBANG" | grep '/nix/store'  > /dev/null ||
        fail "Didn't use /usr/bin/env or /nix/store:\n$SHEBANG"

      if echo "$SHEBANG" | grep 'bash' > /dev/null
      then
        shellcheck "$script"
      fi
      mkdir "$out"
    '') self.music-cmds;

}; {
  music-cmds = mapAttrs' (f: _: {
    name = removeSuffix ".nix" f;
    value = process f;
  }) (readDir ./scripts);

  raw-scripts = self.withDeps (attrValues check)
    (self.runCommand "music-scripts" {
      bin = self.attrsToDirs' "commands" self.music-cmds;
      buildInputs = [ self.makeWrapper ];
    } ''
      echo "Tying the knot between scripts" 1>&2
      mkdir -p "$out/bin"
      for P in "$bin"/*
      do
        F=$(readlink -f "$P")
        N=$(basename    "$P")
        cp "$F"  "$out/bin/$N"
        chmod +x "$out/bin/$N"
        wrapProgram "$out/bin/$N" --prefix PATH : "$out/bin"
      done
    '');

  music-tests = self.callPackage ./tests { scripts = self.raw-scripts; };

  music-scripts =
    self.withDeps (self.allDrvsIn self.music-tests) self.raw-scripts;
}
