#!/bin/sh

case $1 in
  # Debian code names:
  wheezy)
    echo 7:deb:debian-7; exit 0;;
  jessie)
    echo 8:deb:debian-8; exit 0;;
  stretch)
    echo 9:deb:debian-9; exit 0;;
  buster)
    echo 10:deb:debian-10; exit 0;;
  sid)
    echo 10:deb:debian-10; exit 0;;
  
  # Ubuntu code names:
  precise)
    echo 12.4:ubu:ubuntu-12.4; exit 0;;
  trusty)
    echo 14.4:ubu:ubuntu-14.4; exit 0;;
  vivid)
    echo 15.4:ubu:ubuntu-15.4; exit 0;;
  wily)
    echo 15.10:ubu:ubuntu-15.10; exit 0;;
  xenial)
    echo 16.4:ubu:ubuntu-16.4; exit 0;;
  yakkety)
    echo 16.10:ubu:ubuntu-16.10; exit 0;;
  zesty)
    echo 17.4:ubu:ubuntu-17.4; exit 0;;
  artful)
    echo 17.10:ubu:ubuntu-17.10; exit 0;;
  bionic)
    echo 18.4:ubu:ubuntu-18.4; exit 0;;
  cosmic)
    echo 18.10:ubu:ubuntu-18.10; exit 0;;
  
  # Fedora code names:
  fc24)
    echo 24:fc:fedora-24; exit 0;;
  fc25)
    echo 25:fc:fedora-25; exit 0;;
  fc26)
    echo 26:fc:fedora-26; exit 0;;
  fc27)
    echo 27:fc:fedora-27; exit 0;;
  fc28)
    echo 28:fc:fedora-28; exit 0;;
  fc29)
    echo 29:fc:fedora-29; exit 0;;
  fc30)
    echo 30:fc:fedora-30; exit 0;;
  
  # RHEL/CentOS code names:
  el6)
    echo 6:el:epel-6; exit 0;;
  el7)
    echo 7:el:epel-7; exit 0;;
esac
echo 0:unk;
