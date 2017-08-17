#!/bin/sh

# creates skeleton for a software

BASE_DIR='../'

cd `dirname $0`

help(){
    echo "usage: `basename $0` -n <package name>"
    echo ""
    echo "parameters:"
    echo "    -n <package name>: name of the package"
    echo ""
    exit 1 
}

create_new_soft(){
    # create the directory tree
    mkdir -p "${SOFT_PATH}"
    
    # fill the tree
    rsync -a skel/ "${SOFT_PATH}/"
    
    # basic naming
    cd "${SOFT_PATH}"
    for f in `find ./ -type f`
    do
       sed -i "s/@@COMPONENT_NAME@@/${NAME}/g" $f
    done
    mv ./debian/componant.cron.d.ex ./debian/${NAME}.cron.d.ex
    mv ./debian/componant.default.ex ./debian/${NAME}.default.ex
    mv ./debian/componant.service.ex ./debian/${NAME}.service.ex
    mv ./debian/componant.init.ex ./debian/${NAME}.init.ex
    
}

while getopts ":hin:" opt; do
  case $opt in

    h) 
        help
        ;;
    n)
        NAME="$OPTARG"
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

# name must be filled
if [ -z "${NAME}" ]
then
    echo "[ERREUR] missing -n <package name>"
    help
fi 

SOFT_PATH="${BASE_DIR}/${NAME}"

if [ -d "${SOFT_PATH}" ]
then
   echo "[ERROR], package already exists"
   help
fi

create_new_soft

