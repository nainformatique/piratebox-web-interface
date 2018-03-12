#!/bin/bash

upload_dir=/uploads
web_user=www-data

location=`dirname $0`
upload_dir_link=$location/uploads


die() { echo >&2 -e "\nERROR: $@\n"; exit 1; }
run() { "$@"; code=$?; [ $code -ne 0 ] && die "command [$*] failed with error code $code"; }

if [ $UID != 0 ] ; then
  die "You must be root"
fi

apt install clamav-daemon
mkdir -p $upload_dir
ln -s $upload_dir $upload_dir_link
chown -R $web_user:$web_user .
run nginx -c $nginx_conf_file

