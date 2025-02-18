#!/bin/sh

help() {
  cat <<EOF
Usage: $(basename "$0") -v <VERSION_1> -o <OP> -V <VERSION_2>

Arguments:
  -v <VERSION_1> : The first version (left of the comparison operator).
  -o <OP>        : The comparison operator ('>', '>=', '<', '<=', '=').
  -V <VERSION_2> : The second version (right of the comparison operator).

EOF
  exit 0
}

exit_msg() {
  printf "%s\n" "$2" >&2
  exit "$1"
}

while getopts ":hV:o:v:" opt; do
  case $opt in
    h) help ;;
    V) VERSION_2=$(echo "$OPTARG" | tr '-' '.') ;;
    o) OP="$OPTARG" ;;
    v) VERSION_1=$(echo "$OPTARG" | tr '-' '.') ;;
    \?) exit_msg 1 "Invalid option: -$OPTARG" ;;
    :) exit_msg 1 "Option -$OPTARG requires an argument." ;;
  esac
done

[ -z "$VERSION_1" ] && exit_msg 1 "Missing -v <VERSION_1>"
[ -z "$OP" ]        && exit_msg 1 "Missing -o <OP>"
[ -z "$VERSION_2" ] && exit_msg 1 "Missing -V <VERSION_2>"

# Perform version comparison
result=$(awk -v v1="$VERSION_1" -v v2="$VERSION_2" -v op="$OP" 'BEGIN {
  split(v1, v1_arr, ".");
  split(v2, v2_arr, ".");

  # Convert version segments to numerical values
  v1_dec = (v1_arr[1] * 10^12) + (v1_arr[2] * 10^8) + (v1_arr[3] * 10^4) + v1_arr[4];
  v2_dec = (v2_arr[1] * 10^12) + (v2_arr[2] * 10^8) + (v2_arr[3] * 10^4) + v2_arr[4];

  if (op == ">")       {print (v1_dec > v2_dec)  ? "true" : "false";}
  else if (op == ">=") {print (v1_dec >= v2_dec) ? "true" : "false";}
  else if (op == "<")  {print (v1_dec < v2_dec)  ? "true" : "false";}
  else if (op == "<=") {print (v1_dec <= v2_dec) ? "true" : "false";}
  else if (op == "=")  {print (v1_dec == v2_dec) ? "true" : "false";}
  else {print "Invalid comparison operator" > "/dev/stderr"; exit 1;}
}')
ret=$?

echo "$result"
exit $ret
