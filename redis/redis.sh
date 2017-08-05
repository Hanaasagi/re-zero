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
REDISIMAGE="redis:alpine"
REDISDATA="/data/redis/data"


update() {
  docker pull ${REDISIMAGE}

  check_exec_success "$?" "pulling newer redis image"
}


start() {
  docker kill  redis 2>/dev/null
  docker rm -v redis 2>/dev/null

  docker run -d --name redis \
    -v ${REDISDATA}:/data \
    --net=host \
    --log-opt max-size=10m \
    --log-opt max-file=9 \
    ${REDISIMAGE}

  check_exec_success "$?" "start redis container"
}


stop() {
  docker stop redis 2>/dev/null
  docker rm -v redis 2>/dev/null

  check_exec_success "$?" "stop redis container"
}

destroy() {
  stop &>/dev/null
  rm -rf ${REDISDATA}

  check_exec_success "$?" "delete redis data"
}


####################
# start of script
####################

Action=$1

shift

case "$Action" in
  start)   start    ;;
  stop )   stop     ;;
  update ) update   ;;
  destroy) destroy  ;;
  *)
    echo "Usage: start | stop | destroy";;
esac

exit 0
