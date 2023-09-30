(import <nixpkgs> { }).runCommand "music-scripts" {
  buildInputs = [ (import ./. { }) ];
} "exit 1"
