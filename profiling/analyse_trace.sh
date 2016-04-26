#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash bc
#set -x
# Analyse results of proc_trace.sh

function msg {
    echo -e "$*" 1>&2
}

msg "Reading input..."
INPUT=$(cat)
msg "Finished reading input"

# PID to use for the top-level process
TOP=0
function get_top_pid {
    # Guess the top-level PID as the one which has no clone line
    while read -r PIDGTP
    do
        if echo "$INPUT" | grep "clone(.*) = $PIDGTP" > /dev/null
        then
            true # no-op
        else
            TOP="$PIDGTP"
            return
        fi
    done < <(echo "$INPUT" | grep -o "^\[pid *[0-9]*\]" | grep -o "[0-9]*")
}

msg "Finding top-level process ID"
get_top_pid
msg "Found top-level PID: $TOP"

function strip_prefix {
    echo "$1" | sed -e 's/\[pid *[0-9]*\] //g'
}

function pid_of {
    # Try to infer which process a line comes from. This is either a [pid 1234]
    # prefix, or no prefix if the line comes from the top process
    if PRE=$(echo "$1" | grep -o "^\[pid *[0-9]*\]")
    then
        echo "$PRE" | grep -o "[0-9]*"
    else
        echo "$TOP"
    fi
}

function lines_of {
    # Returns lines associated with the given PID
    while read -r LINELO
    do
        PIDLO=$(pid_of "$LINELO")
        [[ "$1" -eq "$PIDLO" ]] && echo "$LINELO"
    done < <(echo "$INPUT")
}

function time_of {
    # Get the timestamp from a line
    strip_prefix "$1" | cut -d ' ' -f 1
}

function find_creation {
    # Find the line (if any) where the given PID was spawned
    echo "$INPUT" | grep "clone(.*) = $1"
}

function creation_time {
    if [[ "$1" -eq "$TOP" ]]
    then
        time_of "$(echo "$INPUT" | head -n1)"
    else
        time_of "$(find_creation "$1")"
    fi
}

function find_destruction {
    # Find the line (if any) where the given PID exited
    if [[ "$1" -eq "$TOP" ]]
    then
        # The top process exits on the last line
        echo "$INPUT" | tail -n1
    else
        lines_of "$1" | grep "+++ exited with"
    fi
}

function destruction_time {
    time_of "$(find_destruction "$1")"
}

function contains_element {
    # Taken from http://stackoverflow.com/a/8574392/884682
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

function gte {
    # $1 >= $2
    (( $(echo "$1 >= $2" | bc -l) ))
}

function is_alive_at {
    # Is PID $1 alive at time $2?
    gte "$2" "$(creation_time "$1")" &&
    gte "$(destruction_time "$1")" "$2"
}

function all_creations {
    echo "$INPUT" | grep "clone("
}

function all_destructions {
    echo "$INPUT" | grep "+++ exited with"
}

function all_lines {
    # We only care about creations and destructions
    all_creations
    all_destructions
}

function all_times {
    # All times, in order
    while read -r LINEAT
    do
        time_of "$LINEAT"
    done < <(all_lines) | sort -gu
}

function higher {
    # Should PID $1 appear above PID $2?
    gte "$(creation_time "$1")" "$(creation_time "$2")"
}

function pids_alive_at {
    for PIDAA in "${PIDS[@]}"
    do
        is_alive_at "$PIDAA" "$1" && echo "$PIDAA"
    done
}

function height_at {
    # Simpler: have spreadsheet chart plotter do the stacking
    if is_alive_at "$1" "$2"
    then
        echo "1"
    else
        echo "0"
    fi
    return

    # How high should PID $1 appear at time $2, when stacked up?
    if is_alive_at "$1" "$2"
    then
        HEIGHT=0 # Start at 0, we will bump ourselves up to 1
        while read -r LINEHA
        do
            if higher "$1" "$LINEHA"
            then
                HEIGHT=$(( HEIGHT + 1 ))
            fi
        done < <(pids_alive_at "$2")
        echo "$HEIGHT"
    else
        echo "0"
    fi
}

function time_to_row {
    # Turn a time $1 into a CSV row
    printf "%s," "$1"
    for PIDTTR in "${PIDS[@]}"
    do
        if is_alive_at "$PIDTTR" "$1"
        then
            printf "%s," "$(height_at "$PIDTTR" "$1")"
        else
            printf "0,"
        fi
    done
    echo ""
}

function get_all_pids {
    # Fill PIDS with all PIDs that were logged
    echo "$TOP"
    echo "$INPUT" | grep -o '\[pid *[0-9]*\]' | grep -o '[0-9]*' | sort -u
}

msg "Looking up all process IDs"
readarray PIDS < <(get_all_pids)
msg "Got all PIDs"

function name_of {
    FOUND=$(lines_of "$1" |
                   grep "execve(" |
                   grep -o 'execve("[^"]*"' |
                   sed -e 's/^execve(//g' | sed -e 's/,//g' |
                   head -n1)
    if [[ -n "$FOUND" ]]
    then
        echo "$FOUND"
    else
        echo "Unknown"
    fi
}

function find_before {
    # Find the closest occurrence of pattern $2 before string $1 in stdin
    CLOSEST=""
    while read -r LINEFB
    do
        if echo "$LINEFB" | grep "$2"
        then
            CLOSEST="$LINEFB"
        fi
        #set -x
        if echo "$LINEFB" | grep -F "$1" > /dev/null
        then
            break
        fi
        #set +x
    done
    echo "$CLOSEST"
}

function make_heading {
    printf "Time,"
    for PIDMH in "${PIDS[@]}"
    do
        COL=$(name_of "$PIDMH")
        printf "%s," "$COL"
    done
    echo ""
}

function all_rows {
    while read -r T
    do
        time_to_row "$T"
    done < <(all_times)
}

function rows_with_heading {
    make_heading
    all_rows
}

function make_csv {
    rows_with_heading | sed -e 's/,$//g'
}

msg "Making CSV"
make_csv
msg "Finished"
