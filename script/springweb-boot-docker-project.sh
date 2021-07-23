#!/bin/bash

BUILD_APP_NAME="build-app"
APP_NAME="app-01"

## src build
function springboot-src-build()
{
  echo "======springboot-src-build======"
  docker build --tag springbootbuildapp:1.0 . -f docker/Dockerfile_Build
  docker run -it --name ${BUILD_APP_NAME} -d --rm -v $(pwd)/springweb:/home/springweb springbootbuildapp:1.0
  docker exec -it ${BUILD_APP_NAME} bash -c "cd /home/springweb/ && ./gradlew build"
  docker stop ${BUILD_APP_NAME}
}

## app image build
function springboot-app-build()
{
  docker build --tag springbootwebapp:1.0 . -f docker/Dockerfile 
}

function start-app()
{
    echo "======start-app======"
    docker run -it --name ${APP_NAME} -d --rm -p 8080:8080 springbootwebapp:1.0
}

function stop-app()
{
    echo "======stop-app======"
    docker stop ${APP_NAME}
}

#=====================================

function start()
{
    start-app
}

function stop()
{
    stop-app
}

function deploy()
{
  springboot-src-build
  springboot-app-build  
}

function status()
{
    echo "find"
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    status
    ;;
  deploy)
    deploy
    ;;
*)
  echo "Usage: $0 {start | stop | restart | status | deploy}"
esac
exit 0
