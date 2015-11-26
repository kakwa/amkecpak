#!/bin/sh

help(){
  cat <<EOF
usage: `basename $0` <args>

<description>

arguments:
  <options>
EOF
  exit 1
}

while getopts ":hn:a:d:" opt; do
  case $opt in
    h)  help;;
    n)  NAME="$OPTARG";;
    a)  ARCH="$OPTARG";;
    d)  DIR="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG" >&2 ;help; exit 1 ;;
    :)  echo "Option -$OPTARG requires an argument." >&2; help; exit 1;;
  esac
done

mkdir -p "${DIR}/src/${NAME}/" || exit 1
tar -xvf "${ARCH}" -C ${DIR}/src/${NAME}/ || exit 1
mv ${DIR}/src/${NAME}/*/* ${DIR}/src/${NAME}/ || exit 1
