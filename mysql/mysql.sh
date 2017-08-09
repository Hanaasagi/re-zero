#!/bin/bash

####################
# utility function
####################

check_non_empty() {
  if [[ "$1" == "" ]]; then
    echo "ERROR: specify $2"
    exit -1
  fi
}

check_exec_success() {
  if [[ "$1" != "0" ]]; then
    echo "ERROR: $2 failed"
    echo "$3"
    exit -1
  fi
}

####################
#
####################

CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOSTADDR="$(ip route get 1 | awk '{print $NF;exit}')"
MYSQLIMAGE="mysql:5.7"
MYSQLDATA="/data/mysql/data"
MYSQLLOG="/data/mysql/logs"


update() {
  docker pull ${MYSQLIMAGE}

  check_exec_success "$?" "pulling newer mysql image"
}


start() {
  docker kill  mysql 2>/dev/null
  docker rm -v mysql 2>/dev/null

  docker run -d --name mysql \
    -v ${MYSQLDATA}:/var/lib/mysql \
    -v ${MYSQLLOG}:/var/log/mysql \
    --net=host \
    --log-opt max-size=10m \
    --log-opt max-file=9 \
    -e MYSQL_ROOT_PASSWORD="root" \
    ${MYSQLIMAGE}

  check_exec_success "$?" "start mysql container"
}


stop() {
  docker stop  mysql 2>/dev/null
  docker rm -v mysql 2>/dev/null

  check_exec_success "$?" "stop mysql container"
}


destroy() {
  stop &>/dev/null
  rm -rf ${MYSQLDATA}
  rm -rf ${MYSQLLOG}

  check_exec_success "$?" "delete mysql data"
}


####################
# start of script
####################

Action=$1

shift

case "$Action" in
  start   )   start   ;;
  stop    )   stop    ;;
  update  )   update  ;;
  destroy )   destroy ;;
  *)
    echo "Usage: start | stop | update | destroy" ;;
esac

exit 0
