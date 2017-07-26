#!/bin/sh


case $1 in
  # Debian code names
  wheezy)
    echo 7:deb;;
  jessie)
    echo 8:deb;;
  stretch)
    echo 9:deb;;
  buster)
    echo 10:deb;;
  sid)
    echo 10:deb;;
  # Ubuntu code names
  precise)
    echo 12.4:ubu;;
  trusty)
    echo 14.4:ubu;;
  vivid)
    echo 15.4:ubu;;
  wily)
    echo 15.10:ubu;;
  xenial)
    echo 16.4:ubu;;
  yakkety)
    echo 16.10:ubu;;
  zesty)
    echo 17.4:ubu;;
  artful)
    echo 17.10:ubu;;
  # Fedora code names
  fc24)
    echo 24:fc;;
  fc25)
    echo 25:fc;;
  fc26)
    echo 26:fc;;
  fc27)
    echo 27:fc;;
  fc28)
    echo 28:fc;;
  fc29)
    echo 29:fc;;
  fc30)
    echo 30:fc;;
  # RHEL code names
  el6)
    echo 6:el;;
  el7)
    echo 7:el;;
  # default
  unknown)
    echo 0:unk;;
  *)
    echo 0:unk;;
esac

