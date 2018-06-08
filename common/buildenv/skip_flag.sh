#!/bin/sh

help(){
  cat <<EOF
usage: `basename $0` -i <IGNORE_STRING> -d <DISTRIBUTION> -v <VERSION>

Check if current dist is to be ignored for build.

Will print 'true' to stdout if the dist/version is to be ignored.

example:
  > `basename $0` -i '=:el:6 <:deb:8' -d deb -v 7
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
  exit $1
}

while getopts ":hi:d:v:" opt; do
  case $opt in

    h) 
        help
        ;;
    i)
        IGNORE_STRING="$OPTARG"
        ;;
    d)
        DIST="$OPTARG"
        ;;
    v)
        VERSION="$OPTARG"
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        help
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        help
        exit 1
        ;;
  esac
done

[ -z "$IGNORE_STRING" ] && exit_msg 1 "missing -i <IGNORE_STRING>"
[ -z "$DIST" ]          && exit_msg 1 "missing -d <DISTRIBUTION>"
[ -z "$VERSION" ]       && exit_msg 1 "missing -v <VERSION>"

SKIPPED=0

for rule in $IGNORE_STRING
do
  rule_type=`echo $rule | cut -d ':' -f 1`
  rule_dist=`echo $rule | cut -d ':' -f 2`
  rule_version=`echo $rule | cut -d ':' -f 3`
  if [ "$rule_dist" = "$DIST" ]
  then
    case $rule_type in
      '>')  op=">";;
      '>=') op=">=";;
      '<') op="<";;
      '<=') op="<=";;
      '=') op="==";;
    esac
    if ! [ -z "$op" ]
    then
      # weird version comparaison
      # limitation:
      # * only work with up to 4 digits
      # * only 3 digit max per section
      # * no rc/beta/alpha possible
      var=`awk "BEGIN {
        # Split each arg in array
        split(\"$VERSION\", FirstVersArr, \".\")
        split(\"$rule_version\", SeconVersArr, \".\")

        # Translate in decimal
        FirstVersDec = FirstVersArr[1] * 10^12 + FirstVersArr[2] * 10^8 + FirstVersArr[3] * 1^4 + FirstVersArr[4]
        SeconVersDec = SeconVersArr[1] * 10^12 + SeconVersArr[2] * 10^8 + SeconVersArr[3] * 1^4 + SeconVersArr[4]

        print (FirstVersDec $op SeconVersDec)}"`
      if [ "$var" -eq 1 ];then SKIPPED=1;fi
    fi
  fi
done

if [ $SKIPPED -eq 1 ]
then
  printf "true\n"
fi
