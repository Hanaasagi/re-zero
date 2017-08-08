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
POSTGRESIMAGE="postgres:alpine"
POSTGRESDATA="/data/postgres/data"


update() {
  docker pull ${POSTGRESIMAGE}

  check_exec_success "$?" "pulling newer postgres image"
}


start() {
  docker kill  postgres 2>/dev/null
  docker rm -v postgres 2>/dev/null

  docker run -d --name postgres                    \
    -v ${POSTGRESDATA}:/var/lib/postgresql/data    \
    -p 127.0.0.1:5432:5432                         \
    --log-opt max-size=10m                         \
    --log-opt max-file=9                           \
    ${POSTGRESIMAGE}

  check_exec_success "$?" "start postgres container"
}


stop() {
  docker stop  postgres 2>/dev/null
  docker rm -v postgres 2>/dev/null

  check_exec_success "$?" "stop postgres container"
}


cli() {
  docker run -it --rm                              \
    --link postgres:postgres                       \
    --name postgres-cli                            \
    ${POSTGRESIMAGE}                               \
    psql -h postgres -U postgres
}


clean() {
  rm -rf ${POSTGRESDATA}

  check_exec_success "$?" "delete postgres data"
}


####################
# start of script
####################

Action=$1

shift

case "$Action" in
  start   ) start    ;;
  stop    ) stop     ;;
  cli     ) cli      ;;
  update  ) update   ;;
  clean   ) clean    ;;
  *)
    echo "Usage: start | stop | cli | update | clean";;
esac

exit 0
