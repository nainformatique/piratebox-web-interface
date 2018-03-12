#!/bin/bash

die() { echo >&2 -e "\nERROR: $@\n"; exit 1; }
run() { "$@"; code=$?; [ $code -ne 0 ] && die "command [$*] failed with error code $code"; }

if [ $UID != 0 ] ; then
  die "You must be root"
fi

apt install clamav-daemon
