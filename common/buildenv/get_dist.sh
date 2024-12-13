#!/bin/sh
#
case $1 in
  # Debian code names and version mapping:
  wheezy|deb7)
    echo 7:deb:debian-7; exit 0;;
  jessie|deb8)
    echo 8:deb:debian-8; exit 0;;
  stretch|deb9)
    echo 9:deb:debian-9; exit 0;;
  buster|deb10)
    echo 10:deb:debian-10; exit 0;;
  bullseye|deb11)
    echo 11:deb:debian-11; exit 0;;
  bookworm|deb12)
    echo 12:deb:debian-12; exit 0;;
  trixie|deb13)
    echo 13:deb:debian-13; exit 0;;
  sid|deb14)
    echo 14:deb:debian-14; exit 0;;

  # Ubuntu code names and version mapping:
  precise|ubu12.4)
    echo 12.4:ubu:ubuntu-12.4; exit 0;;
  trusty|ubu14.4)
    echo 14.4:ubu:ubuntu-14.4; exit 0;;
  vivid|ubu15.4)
    echo 15.4:ubu:ubuntu-15.4; exit 0;;
  wily|ubu15.10)
    echo 15.10:ubu:ubuntu-15.10; exit 0;;
  xenial|ubu16.4)
    echo 16.4:ubu:ubuntu-16.4; exit 0;;
  yakkety|ubu16.10)
    echo 16.10:ubu:ubuntu-16.10; exit 0;;
  zesty|ubu17.4)
    echo 17.4:ubu:ubuntu-17.4; exit 0;;
  artful|ubu17.10)
    echo 17.10:ubu:ubuntu-17.10; exit 0;;
  bionic|ubu18.4)
    echo 18.4:ubu:ubuntu-18.4; exit 0;;
  cosmic|ubu18.10)
    echo 18.10:ubu:ubuntu-18.10; exit 0;;
  disco|ubu19.4)
    echo 19.4:ubu:ubuntu-19.4; exit 0;;
  eoan|ubu19.10)
    echo 19.10:ubu:ubuntu-19.10; exit 0;;
  focal|ubu20.4)
    echo 20.4:ubu:ubuntu-20.4; exit 0;;
  groovy|ubu20.10)
    echo 20.10:ubu:ubuntu-20.10; exit 0;;
  hirsute|ubu21.04)
    echo 21.04:ubu:ubuntu-21.04; exit 0;;
  impish|ubu21.10)
    echo 21.10:ubu:ubuntu-21.10; exit 0;;
  jammy|ubu22.04)
    echo 22.04:ubu:ubuntu-22.04; exit 0;;
  lunar|ubu23.04)
    echo 23.04:ubu:ubuntu-23.04; exit 0;;
  mantic|ubu23.10)
    echo 23.10:ubu:ubuntu-23.10; exit 0;;
  noble|ubu24.04)
    echo 24.04:ubu:ubuntu-24.04; exit 0;;
  oracular|ubu24.10)
    echo 24.10:ubu:ubuntu-24.10; exit 0;;
  plucky|ubu25.04)
    echo 25.04:ubu:ubuntu-25.04; exit 0;;

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
  fc36)
    echo 36:fc:fedora-36; exit 0;;
  fc37)
    echo 37:fc:fedora-37; exit 0;;
  fc38)
    echo 38:fc:fedora-38; exit 0;;
  fc39)
    echo 39:fc:fedora-39; exit 0;;
  fc40)
    echo 40:fc:fedora-40; exit 0;;
 
  # RHEL/CentOS code names:
  el6)
    echo 6:el:rocky+epel-6; exit 0;;
  el7)
    echo 7:el:rocky+epel-7; exit 0;;
  el8)
    echo 8:el:rocky+epel-8; exit 0;;
  el9)
    echo 9:el:rocky+epel-9; exit 0;;
  el10)
    echo 10:el:rocky+epel-10; exit 0;;
  el11)
    echo 11:el:rocky+epel-11; exit 0;;

  # Generic mapping case:
  deb[0-9]*)
    ver=`echo $1 | sed 's/deb//'`; echo "$ver:deb:debian-$ver"; exit 0;;
  ubu[0-9]*\.[0-9]*)
    ver=`echo $1 | sed 's/ubu//'`; echo "$ver:ubu:ubuntu-$ver"; exit 0;;
  fc[0-9]*)
    ver=`echo $1 | sed 's/fc//'`; echo "$ver:fc:fedora-$ver"; exit 0;;
  el[0-9]*)
    ver=`echo $1 | sed 's/el//'`; echo "$ver:el:rocky+epel-$ver"; exit 0;;
  *)
esac
echo 0:unk;
