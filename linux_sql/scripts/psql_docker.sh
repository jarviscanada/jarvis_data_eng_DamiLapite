#!/bin/bash

cmd=$1
db_username=$2
db_password=$3

sudo systemctl status docker || sudo systemctl start docker

docker container inspect $db_username
container_status=$?


case $cmd in
  create)

  if [ $container_status -eq 0 ]; then
  		echo 'Container already exists'
  		exit 1
  fi

  if [ $# -ne 3 ]; then
      echo 'Create requires username and password'
      exit 1
  fi

  docker volume create pgdata
  docker run --name $db_username -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
  exit $?
  ;;

  start|stop)
  if [ $container_status -ne 0 ]; then
  		echo 'Container does not exists'
  		exit 1
  fi

  docker container $cmd $db_username
  exit $?
  ;;

  *)
  echo 'Illegal command'
  echo 'Commands: start|stop|create'
  exit 1
  ;;
esac

exit 0``