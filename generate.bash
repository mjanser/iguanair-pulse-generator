#!/bin/bash

OPTIND=1

ones=""
zeroes=""
header=""
tail=""
vendor=""
reverse=0

while getopts "h:t:1:0:v:r" opt; do
    case "$opt" in
    1)  ones=$OPTARG
        ;;
    0)  zeroes=$OPTARG
        ;;
    h)  header=$OPTARG
        ;;
    t)  tail=$OPTARG
        ;;
    v)  vendor=$OPTARG
        ;;
    r)  reverse=1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift
command=$@

display_usage() {
    echo "Usage: $0 -1 ONE_DEF -0 ZERO_DEF [-h HEADER_DEF] [-t TAIL_DEF] [-v VENDOR_HEX] [-r] COMMAND_HEX"
    echo "Help: ONE_DEF, ZERO_DEF, HEADER_DEF and TAIL_DEF are defined by pulses and spaces separated by a whitespace."
    echo "      VENDOR_HEX and COMMAND_HEX are defined by plain hex numbers."
    echo "      If the option -r is specified, the vendor and command pulses are reversed."
}

[ -z "$command" ] && display_usage && exit 1
[ -z "$ones" ] && display_usage && exit 1
[ -z "$zeroes" ] && display_usage && exit 1

pulses() {
    type="pulse"
    for j in $1; do
        echo "$type $j"

        [ $type == "pulse" ] && type="space" || type="pulse"
    done
}

binary_pulses() {
    for (( i=0; i<${#1}; i++ )); do
        if [ ${1:$i:1} -eq 1 ]; then
            pulses "$ones"
        else
            pulses "$zeroes"
        fi
    done
}

hex_pulses() {
    hex2bin "$1"
    binary_pulses "$BIN"
}

BIN=""
hex2bin() {
    for j in $1; do
        BIN=$(printf %016d $(echo "obase=2; ibase=16; $j" | bc ))
    done
    [ $reverse -eq 1 ] && BIN=$(echo $BIN | rev)
}


pulses "$header"
hex_pulses "$vendor"
hex_pulses "$command"
pulses "$tail"
