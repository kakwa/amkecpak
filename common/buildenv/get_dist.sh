#!/bin/sh


case $1 in
  wheezy)
    echo 7;;
  jessie)
    echo 8;;
  stretch)
    echo 9;;
  buster)
    echo 10;;
  sid)
    echo 10;;
  unknown)
    echo 00;;
  *)
    echo $1;;
esac

