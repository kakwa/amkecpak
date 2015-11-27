#!/bin/sh

DISTID=`lsb_release -is`

RELEASE=`lsb_release -rs`
MAJOR=`echo $RELEASE | sed 's/\..*$//'`

if echo $DISTID | grep -iq 'Redhat\|CentOS'
then
    PKGDID='el'
elif echo $DISTID | grep -iq 'Fedora'
then
    PKGDID='fc'
elif echo $DISTID | grep -iq 'Debian'
then
    PKGDID='deb'
else
    PKGDID='unk'
    MAJOR=''
fi

if echo $MAJOR | grep -iq 'unstable'
then
    MAJOR='U'
fi

echo "${PKGDID}${MAJOR}"
