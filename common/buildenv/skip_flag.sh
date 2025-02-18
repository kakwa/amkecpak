#!/bin/sh

help(){
  cat <<EOF
usage: $(basename "$0") -i <IGNORE_STRING> -d <DISTRIBUTION> -v <VERSION>
Check if current dist is to be ignored for build.
Will print 'true' to stdout if the dist/version is to be ignored.

example:
  > $(basename "$0") -i '=:el:6 <:deb:8' -d deb -v 7
  true

arguments:
  -i <IGNORE_STRING>: the ignore string
  -d <DISTRIBUTION>:  the distribution code name to check
  -v <VERSION>:       the specific version to check

ignore string format:
The ignore space is a space separated list of rules.
each rule have the format "<op>:<dist>:<version>", with:
  <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
  <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
  <version>: the version number to ignore
EOF
  exit 1
}

exit_msg(){
  code=$1
  msg="$2"
  printf "%s\n" "$msg" >&2
  exit $code
}

while getopts ":hi:d:v:" opt; do
  case $opt in

    h) help;;
    i) IGNORE_STRING="$OPTARG";;
    d) DIST="$OPTARG";;
    v) VERSION="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG" >&2;help;exit 1;;
    :)  echo "Option -$OPTARG requires an argument." >&2 ;help; exit 1;;
  esac
done

[ -z "$IGNORE_STRING" ] && exit_msg 1 "missing -i <IGNORE_STRING>"
[ -z "$DIST" ]          && exit_msg 1 "missing -d <DISTRIBUTION>"
[ -z "$VERSION" ]       && exit_msg 1 "missing -v <VERSION>"

for rule in $IGNORE_STRING
do
  rule_type=`echo $rule | cut -d ':' -f 1`
  rule_dist=`echo $rule | cut -d ':' -f 2`
  rule_version=`echo $rule | cut -d ':' -f 3`

  [ "$rule_dist" = "$DIST" ] || continue

  # Perform version comparison
  result=$(awk -v v1="$VERSION" -v v2="$rule_version" -v op="$rule_type" 'BEGIN {
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
    else {print "Invalid comparison operator" > "/dev/stderr"; exit 1};
  }')
  [ $? -ne 0 ] && exit_msg 1 "comparison error"

  [ "$result" = "true" ] && printf "true\n" && exit 0
done
