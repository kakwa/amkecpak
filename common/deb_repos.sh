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

create_deb_repo(){
    # gen metadata
    mkdir -p $OUTPUT_DIR/conf/
    cat > $OUTPUT_DIR/conf/distributions << EOF 
Origin: $ORIGIN
Label: $ORIGIN
Suite: stable
Codename: `lsb_release -sc`
Version: 3.1
Architectures: `dpkg --print-architecture`
Components: contrib
Description: Repository containing misc packages 
SignWith: $KEY
EOF

    gret=0
    cd $OUTPUT_DIR/
    for deb in $PKGS
    do
        reprepro -P optional -S $ORIGIN -C contrib -Vb . includedeb stable $deb
        ret=$?
        if [ $ret -ne 0 ]
        then  gret=1
        fi
    done
    cd -
    [ $gret -eq 0 ] || exit 1
}

while getopts ":ho:O:p:k:" opt; do
  case $opt in
    h)  help;;
    p)  PKGS="$OPTARG";;
    o)  OUTPUT_DIR="$OPTARG";;
    O)  ORIGIN="$OPTARG";;
    k)  KEY="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG" >&2 ;help; exit 1 ;;
    :)  echo "Option -$OPTARG requires an argument." >&2; help; exit 1;;
  esac
done

create_deb_repo
