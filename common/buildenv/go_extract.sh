#!/bin/sh

help(){
  cat <<EOF
usage: `basename $0` -n <go module name> -a <archive> -d <gopath directory>

extract go upstream archive in module name

example: `basename $0` -a gogs-0.7.1.tar.gz -n 'github.com/gogits/gogs/' -d \$GOPATH

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
