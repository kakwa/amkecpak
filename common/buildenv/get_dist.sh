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
  bullseye)
    echo 11:deb:debian-11; exit 0;;
  sid)
    echo 12:deb:debian-12; exit 0;;
  
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
  disco)
    echo 19.4:ubu:ubuntu-19.4; exit 0;;
  eoan)
    echo 19.10:ubu:ubuntu-19.10; exit 0;;
  focal)
    echo 20.4:ubu:ubuntu-20.4; exit 0;;
  groovy)
    echo 20.10:ubu:ubuntu-20.10; exit 0;;
  hirsute)
    echo 21.04:ubu:ubuntu-21.04; exit 0;;

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
  fc31)
    echo 31:fc:fedora-31; exit 0;;
  fc32)
    echo 32:fc:fedora-32; exit 0;;
  fc33)
    echo 33:fc:fedora-33; exit 0;;
  fc34)
    echo 34:fc:fedora-34; exit 0;;
  fc35)
    echo 35:fc:fedora-35; exit 0;;
  
  # RHEL/CentOS code names:
  el6)
    echo 6:el:epel-6; exit 0;;
  el7)
    echo 7:el:epel-7; exit 0;;
  el8)
    echo 8:el:epel-8; exit 0;;
esac
echo 0:unk;
