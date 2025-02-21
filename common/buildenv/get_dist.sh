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

# Generic Debian/Ubuntu mapping helper function
get_codename() {
    local version=$1
    local type=$2
    local codename=""

    # Check local debootstrap scripts first
    if [ -d "/usr/share/debootstrap/scripts" ]; then
        for script in /usr/share/debootstrap/scripts/*; do
            base_script=$(basename "$script")

			# Skip versions already present
			grep -q ":$base_script\"" $0 && continue

			MIRROR=$(sed -n 's/ *default_mirror *//p' "$script" | head -n 1)
			if [ -z "${MIRROR}" ]
			then
            case $type in
                "deb") MIRROR="https://deb.debian.org/debian";;
                "ubu") MIRROR="https://archive.ubuntu.com/ubuntu";;
				*)     MIRROR="https://deb.debian.org/debian";;
            esac
			fi
			data=$(curl -s "${MIRROR}/dists/${base_script}/Release" --range 0-512 | tr '[:upper:]' '[:lower:]')
			if echo "$data" | grep -q "origin: ${type}" || echo "$data" | grep -q "label: ${type}" &&  echo "$data" | grep -q "version: ${version}"
			then
				codename=$base_script
				break
			fi
        done
    fi

    # If no codename found, use development versions as a fallback
    if [ -z "$codename" ]; then
        case $type in
            "deb") codename="unstable";;
            "ubu") codename="devel";;
			*)     codename="$3";;
        esac
    fi
    echo "$codename"
}

case $1 in
  # Debian versions
  wheezy|deb7) echo "7:deb:debian-7:wheezy" ;;
  jessie|deb8) echo "8:deb:debian-8:jessie" ;;
  stretch|deb9) echo "9:deb:debian-9:stretch" ;;
  buster|deb10) echo "10:deb:debian-10:buster" ;;
  bullseye|deb11) echo "11:deb:debian-11:bullseye" ;;
  bookworm|deb12) echo "12:deb:debian-12:bookworm" ;;
  trixie|deb13) echo "13:deb:debian-13:trixie" ;;
  sid|deb14) echo "14:deb:debian-14:sid" ;;

  # Ubuntu versions
  precise|ubu12.04) echo "12.04:ubu:ubuntu-12.04:precise" ;;
  trusty|ubu14.04) echo "14.04:ubu:ubuntu-14.04:trusty" ;;
  vivid|ubu15.04) echo "15.04:ubu:ubuntu-15.04:vivid" ;;
  wily|ubu15.10) echo "15.10:ubu:ubuntu-15.10:wily" ;;
  xenial|ubu16.04) echo "16.04:ubu:ubuntu-16.04:xenial" ;;
  yakkety|ubu16.10) echo "16.10:ubu:ubuntu-16.10:yakkety" ;;
  zesty|ubu17.04) echo "17.04:ubu:ubuntu-17.04:zesty" ;;
  artful|ubu17.10) echo "17.10:ubu:ubuntu-17.10:artful" ;;
  bionic|ubu18.04) echo "18.04:ubu:ubuntu-18.04:bionic" ;;
  cosmic|ubu18.10) echo "18.10:ubu:ubuntu-18.10:cosmic" ;;
  disco|ubu19.04) echo "19.04:ubu:ubuntu-19.04:disco" ;;
  eoan|ubu19.10) echo "19.10:ubu:ubuntu-19.10:eoan" ;;
  focal|ubu20.04) echo "20.04:ubu:ubuntu-20.04:focal" ;;
  groovy|ubu20.10) echo "20.10:ubu:ubuntu-20.10:groovy" ;;
  hirsute|ubu21.04) echo "21.04:ubu:ubuntu-21.04:hirsute" ;;
  impish|ubu21.10) echo "21.10:ubu:ubuntu-21.10:impish" ;;
  jammy|ubu22.04) echo "22.04:ubu:ubuntu-22.04:jammy" ;;
  lunar|ubu23.04) echo "23.04:ubu:ubuntu-23.04:lunar" ;;
  mantic|ubu23.10) echo "23.10:ubu:ubuntu-23.10:mantic" ;;
  noble|ubu24.04) echo "24.04:ubu:ubuntu-24.04:noble" ;;
  oracular|ubu24.10) echo "24.10:ubu:ubuntu-24.10:oracular" ;;
  plucky|ubu25.04) echo "25.04:ubu:ubuntu-25.04:plucky" ;;

  # Generic Mapping for fc/RHEL
  fc[0-9]*) echo "${1#fc}:fc:fedora-${1#fc}:${1}" ;;
  el[0-9]*) echo "${1#el}:el:rocky+epel-${1#el}:${1}" ;;

  # Generic Debian/Ubuntu mapping
  deb[0-9]*)
    version="${1#deb}"
    codename=$(get_codename "$version" "deb" "$1")
    echo "${version}:deb:debian-${version}:${codename}"
    ;;

  ubu[0-9]*\.[0-9]*)
    version="${1#ubu}"
    codename=$(get_codename "$version" "ubu" "$1")
    echo "${version}:ubu:ubuntu-${version}:${codename}"
    ;;

  *) echo "0:unk";exit 1;;
esac
exit 0
