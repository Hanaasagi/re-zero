#!/bin/bash

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



CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOSTNAME="$(hostname)"
HOSTADDR="$(ip route get 1 | awk '{print $NF;exit}')"
RABBITMQIMAGE="rabbitmq:alpine"
RABBITMQDATA="/data/rabbitmq/data"

RABBITMQ_USER=root
RABBITMQ_PASS=root

setup(){
  docker run --rm \
    -e RABBITMQ_DEFAULT_USER=${RABBITMQ_USER} \
    -e RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASS} \
    -v ${RABBITMQDATA}:/var/lib/rabbitmq \
    --net=host \
    ${RABBITMQIMAGE} bash -c 'rabbitmqctl add_vhost shanbay
			 rabbitmqctl add_user celery celery
			 rabbitmqctl set_permissions -p shanbay celery ".*" ".*" ".*"
			 rabbitmqctl set_permissions -p shanbay beeblio ".*" ".*" ".*"'

}


start() {
  docker kill  rabbitmq 2>/dev/null
  docker rm -v rabbitmq 2>/dev/null

  docker run -d --name rabbitmq \
    -e RABBITMQ_DEFAULT_USER=${RABBITMQ_USER} \
    -e RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASS} \
    -v ${RABBITMQDATA}:/var/lib/rabbitmq \
    --net=host \
    --restart=always \
    --log-opt max-size=10m \
    --log-opt max-file=9 \
    ${RABBITMQIMAGE}

  check_exec_success "$?" "start rabbitmq container"
}


stop() {
  docker stop  rabbitmq 2>/dev/null
  docker rm -v rabbitmq 2>/dev/null

  check_exec_success "$?" "stop rabbitmq container"
}


shell() {
  docker run -it --rm \
    -v ${RABBITMQDATA}:/var/lib/rabbitmq \
    -e RABBITMQ_DEFAULT_USER=${RABBITMQ_USER} \
    -e RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASS} \
    --net=host \
    ${RABBITMQIMAGE} /bin/bash
}


clean() {
  rm -rf ${RABBITMQDATA}

  check_exec_success "$?" "delete rabbitmq data"
}


##################
# Start of script
##################

Action=$1

shift

case "$Action" in
  start   ) start    ;;
  stop    ) stop     ;;
  shell   ) shell    ;;
  clean   ) clean    ;;
  *)
    echo "Usage: start | stop | shell | clean";;
esac

exit 0
