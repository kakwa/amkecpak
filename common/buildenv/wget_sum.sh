#!/bin/sh

help(){
  cat <<EOF
usage: `basename $0` -u <url> -o <outfile> \\
    [-m <manifest file>] [-c] [-C <cache dir>]

Download files, checking them against a manifest

arguments:
  -u <url>: url of the file to download
  -o <outfile>: path to output file
  -m <manifest file>: path to manifest file (file containing hashes)
  -c: flag to fill the manifest file 
  -C <cache dir>: directory where to cache downloads
EOF
  exit 1
}


exit_error(){
    echo "$1"
    rm -f "${OUTFILE}"
    rm -f "${CACHE_DIR}/${SOURCE_FILE}"
    exit 1
}


trap -- 'exit_error "[ERROR] Download interrupted"' INT TERM

[ -z "$CREATE_SUM" ] && CREATE_SUM=1

MANIFEST_FILE="`dirname $0`/../MANIFEST"

while getopts ":hu:o:m:cC:" opt; do
  case $opt in

    h) 
        help
        ;;
    u)
        URL="$OPTARG"
        ;;
    o)
        OUTFILE="$OPTARG"
        ;;
    m)
        MANIFEST_FILE="$OPTARG"
        ;;
    c)
        CREATE_SUM=0
        ;;
    C)
        CACHE_DIR="$OPTARG"
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

[ -z "$URL" ] && exit_error "[ERROR] missing -u <url> arg"
[ -z "$OUTFILE" ] && exit_error "[ERROR] missing -o <out> arg"

SOURCE_FILE="`basename ${OUTFILE}`"
if [ -e "$MANIFEST_FILE" ]
then
    EXPECTED_SUM="`sed \"s/$SOURCE_FILE=\(.*\)/\1/p;d\" $MANIFEST_FILE`"
else
    EXPECTED_SUM=""
fi

if ! [ -z "${CACHE_DIR}" ]
then
    if ! [ -f "${CACHE_DIR}/${SOURCE_FILE}" ]
    then
        wget "$URL" -O "${CACHE_DIR}/${SOURCE_FILE}" || exit_error "[ERROR] download failed"
    fi
    cp "${CACHE_DIR}/${SOURCE_FILE}" "${OUTFILE}"
else
    wget "$URL" -O ${OUTFILE} || exit_error "[ERROR] download failed"
fi

SUM=`sha512sum $OUTFILE -t |sed "s/\ .*//"`

#EXPECTED_SUM=`eval echo ${SOURCE_FILE}`

if [ $CREATE_SUM -eq 0 ]
then
    [ -e "$MANIFEST_FILE" ] || touch $MANIFEST_FILE
    if [ -z "$EXPECTED_SUM" ]
    then
        echo "$SOURCE_FILE=$SUM" >>$MANIFEST_FILE
    else
        sed -i "s/$SOURCE_FILE=.*/$SOURCE_FILE=$SUM/" $MANIFEST_FILE
    fi
else
    [ "$EXPECTED_SUM" = "$SUM" ] || exit_error "[ERROR] Bad checksum for '$URL'\nexpected: $EXPECTED_SUM\ngot:     $SUM"
fi
