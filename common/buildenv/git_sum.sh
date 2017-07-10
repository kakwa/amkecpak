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
    exit 1
}

TMP_CO_DIR=`mktemp -d`
mkdir -p $TMP_CO_DIR

[ -z "$CREATE_SUM" ] && CREATE_SUM=1

MANIFEST_FILE="`dirname $0`/../MANIFEST"

while getopts ":hu:o:m:cC:t:r:" opt; do
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
    t)
        TAG="$OPTARG"
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
    r)
        REVISION="$OPTARG"
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

CO_DIR=`basename $URL`

SOURCE_FILE="`basename ${OUTFILE}`"
if [ -e "$MANIFEST_FILE" ]
then
    EXPECTED_SUM="`sed \"s/$SOURCE_FILE=\(.*\)/\1/p;d\" $MANIFEST_FILE`"
else
    EXPECTED_SUM=""
fi

org_dir=`pwd`
if ! [ -z "${CACHE_DIR}" ]
then
    if ! [ -f "${CACHE_DIR}/${SOURCE_FILE}" ]
    then
        cd $TMP_CO_DIR
	git clone ${URL} ${CO_DIR} || exit_error "[ERROR] download failed"
	cd ${CO_DIR}
	if [ -z "$REVISION" ]
	then
	    git checkout tags/$TAG || exit_error "[ERROR] tag checkout failed"
        else
	    git checkout $REVISION || exit_error "[ERROR] revision checkout failed"
	fi
        cd $org_dir
	tar -zcvf ${CACHE_DIR}/${SOURCE_FILE} -C "${TMP_CO_DIR}/" ${CO_DIR} || exit_error "[ERROR] failed to create archive"
    else
	tar -xf ${CACHE_DIR}/${SOURCE_FILE} -C "${TMP_CO_DIR}/"
    fi
    cp "${CACHE_DIR}/${SOURCE_FILE}" "${OUTFILE}"
else
    git clone ${URL} ${CO_DIR} || exit_error "[ERROR] download failed"
    git checkout tags/$TAG || exit_error "[ERROR] tag checkout failed"
    tar -zcvf ${OUTFILE} "${TMP_CO_DIR}/${CO_DIR}" || exit_error "[ERROR] failed to create archive"
fi
cd $org_dir

SUM=`cd $TMP_CO_DIR/${CO_DIR} && git rev-parse HEAD && cd - 2>&1 >/dev/null`

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
    [ "$EXPECTED_SUM" = "$SUM" ] || exit_error "[ERROR] Bad checksum for '$URL'\nexpected: '$EXPECTED_SUM'\ngot:      '$SUM'"
fi

rm -rf -- "${TMP_CO_DIR}"

