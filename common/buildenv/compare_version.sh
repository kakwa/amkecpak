#!/bin/sh

help(){
  cat <<EOF
usage: `basename $0` -v <VERSION_1> -o <OP> -V <VERSION_2>

arguments:
  -v <VERSION_1>: the version (left of op) 
  -o <OP>:        the comparare operation 
  -V <VERSION_2>: the version (right of op)

Operation allowed
<OP>:      the operation (must be  '>', '>=', '<', '<=' or '=')
EOF
  exit 1
}

exit_msg(){
  code=$1
  msg="$2"
  printf "%s\n" "$msg" >&2
  exit $1
}

while getopts ":hV:o:v:" opt; do
  case $opt in

    h) 
        help
        ;;
    V)
        VERSION_2=`echo $OPTARG | sed 's/-/./g'`
        ;;
    o)
        OP="$OPTARG"
        ;;
    v)
        VERSION_1=`echo $OPTARG | sed 's/-/./g'`
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

[ -z "$VERSION_1" ] && exit_msg 1 "missing -v <VERSION_1>"
[ -z "$OP" ]        && exit_msg 1 "missing -o <OP>"
[ -z "$VERSION_2" ] && exit_msg 1 "missing -V <VERSION_2>"

case $OP in
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
  # * only 4 digit max per section
  # * no rc/beta/alpha possible
  var=`awk "BEGIN {
    # Split each arg in array
    split(\"$VERSION_1\", FirstVersArr, \".\")
    split(\"$VERSION_2\", SeconVersArr, \".\")

    # Translate in decimal
    FirstVersDec = FirstVersArr[1] * 10^12 + FirstVersArr[2] * 10^8 + FirstVersArr[3] * 1^4 + FirstVersArr[4]
    SeconVersDec = SeconVersArr[1] * 10^12 + SeconVersArr[2] * 10^8 + SeconVersArr[3] * 1^4 + SeconVersArr[4]

    print (FirstVersDec $op SeconVersDec)}"`
  if [ "$var" -eq 1 ];
  then
    echo "true"
  else
    echo "false"
  fi
else
  exit 1
fi


