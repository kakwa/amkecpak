#!/bin/sh


help() {
  cat <<EOF
Usage: $(basename "$0") <distro_version>

Maps a distribution name/version to a standardized format.

Supported Distributions:
  - Debian:      deb<N> (e.g., deb10) or codename (e.g., buster)
  - Ubuntu:      ubu<N>.<M> (e.g., ubu20.04) or codename (e.g., focal)
  - Fedora:      fc<N> (e.g., fc40)
  - RHEL/CentOS: el<N> (e.g., el9)

Examples:
  $(basename "$0") focal
  $(basename "$0") ubu22.04
  $(basename "$0") fc39
  $(basename "$0") el8
EOF
  exit 1
}

# Validate input arguments
[ "$#" -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]  && help

case $1 in
  # Debian versions
  wheezy|deb7) echo "7:deb:debian-7" ;;
  jessie|deb8) echo "8:deb:debian-8" ;;
  stretch|deb9) echo "9:deb:debian-9" ;;
  buster|deb10) echo "10:deb:debian-10" ;;
  bullseye|deb11) echo "11:deb:debian-11" ;;
  bookworm|deb12) echo "12:deb:debian-12" ;;
  trixie|deb13) echo "13:deb:debian-13" ;;
  sid|deb14) echo "14:deb:debian-14" ;;

  # Ubuntu versions
  precise|ubu12.04) echo "12.04:ubu:ubuntu-12.04" ;;
  trusty|ubu14.04) echo "14.04:ubu:ubuntu-14.04" ;;
  vivid|ubu15.04) echo "15.04:ubu:ubuntu-15.04" ;;
  wily|ubu15.10) echo "15.10:ubu:ubuntu-15.10" ;;
  xenial|ubu16.04) echo "16.04:ubu:ubuntu-16.04" ;;
  yakkety|ubu16.10) echo "16.10:ubu:ubuntu-16.10" ;;
  zesty|ubu17.04) echo "17.04:ubu:ubuntu-17.04" ;;
  artful|ubu17.10) echo "17.10:ubu:ubuntu-17.10" ;;
  bionic|ubu18.04) echo "18.04:ubu:ubuntu-18.04" ;;
  cosmic|ubu18.10) echo "18.10:ubu:ubuntu-18.10" ;;
  disco|ubu19.04) echo "19.04:ubu:ubuntu-19.04" ;;
  eoan|ubu19.10) echo "19.10:ubu:ubuntu-19.10" ;;
  focal|ubu20.04) echo "20.04:ubu:ubuntu-20.04" ;;
  groovy|ubu20.10) echo "20.10:ubu:ubuntu-20.10" ;;
  hirsute|ubu21.04) echo "21.04:ubu:ubuntu-21.04" ;;
  impish|ubu21.10) echo "21.10:ubu:ubuntu-21.10" ;;
  jammy|ubu22.04) echo "22.04:ubu:ubuntu-22.04" ;;
  lunar|ubu23.04) echo "23.04:ubu:ubuntu-23.04" ;;
  mantic|ubu23.10) echo "23.10:ubu:ubuntu-23.10" ;;
  noble|ubu24.04) echo "24.04:ubu:ubuntu-24.04" ;;
  oracular|ubu24.10) echo "24.10:ubu:ubuntu-24.10" ;;
  plucky|ubu25.04) echo "25.04:ubu:ubuntu-25.04" ;;

  # Generic Mapping for fc/RHEL
  fc[0-9]*) echo "${1#fc}:fc:fedora-${1#fc}" ;;
  el[0-9]*) echo "${1#el}:el:rocky+epel-${1#el}" ;;
  # Generic Debian/Ubuntu mapping
  deb[0-9]*) echo "${1#deb}:deb:debian-${1#deb}" ;;
  ubu[0-9]*\.[0-9]*) echo "${1#ubu}:ubu:ubuntu-${1#ubu}" ;;

  *) echo "0:unk";exit 1;;
esac
exit 0
