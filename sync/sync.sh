#! /usr/bin/env bash

type=$1

if [ -z "${type}"  ]; then
  echo "need a type"
  exit 1
fi

case "$type" in
  web)
    syname="webhuohuo"
    ;;
  webapp)
    syname="webapphuohuo"
    ;;
  cms)
    syname="cmshuohuo"
    ;;
  askweb)
    syname="askwebdevelop"
    ;;
  askwebapp)
    syname="askwebappdevelop"
    ;;
  sxyweb)
    syname="sxywebhuohuo"
    ;;
  askwebcms)
    syname="askcmsdevelop"
    ;;
  restful)
    syname="servicehuohuo"
    ;;
esac

if [ -z "$syname" ]; then
  echo "type must be web, webapp, cms"
  exit 1
fi

pid=/tmp/unicorn-${type}.pid

# stop service
if [ -f ${pid} ]; then
  echo "shutdown servic"
  uwsgi --stop ${pid}
fi

echo "removing files"
rm -rf ./${type}/server

rsync -avzP --delete --exclude="logs/*"  --password-file=/etc/rsync.pas work@120.25.103.109::${syname} ./${type}

if [ $? != 0 ]; then
  echo "updating code failed"
  exit 1;
fi

# change user to vagrant
if [ $type = "restful" ]; then
  cd ${type}
else
  cd ${type}/server
fi

# start service
ini=./uwsgi_vagrant.ini
if [ -f ${ini}  ]; then
  echo "starting service..."
  uwsgi ${ini}
else
  echo "require uwsgi_vagrant.ini"
  exit 1
fi
