#!/bin/bash

location=`dirname $0`
upload_dir=/uploads
upload_dir_link=$location/uploads

webroot=$location/webroot
web_user=www-data
nginx_conf_file=$location/nginx.conf

###############################################################################
#               Configurations end
###############################################################################

die() { echo >&2 -e "\nERROR: $@\n"; exit 1; }
run() { "$@"; code=$?; [ $code -ne 0 ] && die "command [$*] failed with error code $code"; }

if [ $UID != 0 ] ; then
  die "You must be root"
fi

apt install -y clamav-daemon nginx php7.0-fpm

systemctl start php7.0-fpm
systemctl stop nginx
systemctl disable nginx
killall nginx 2> /dev/null

read -d '' nginx_conf <<- EOF
user $web_user;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {worker_connections 768;}
http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  client_max_body_size 10G;

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  gzip on;
  gzip_disable "msie6";
  include /etc/nginx/conf.d/*.conf;
  
  server {
    listen 80;
    server_name _;
    root $webroot;
    
    location / {
      index index.php;
      try_files \$uri \$uri/ =404;
    }
    location ~ \.php$ {
      fastcgi_pass unix:/run/php/php7.0-fpm.sock;
      fastcgi_index index.php;
      include /etc/nginx/fastcgi.conf;
    }
  }
}
EOF
echo "$nginx_conf" > $nginx_conf_file

mkdir -p $upload_dir
ln -fns $upload_dir $upload_dir_link
chown -R $web_user:$web_user .
run nginx -c $nginx_conf_file
