#!/bin/bash

APP_NAME="app-01"

function docker-image-build()
{
    echo "docker-image-build"
    docker build --tag springbootapp:1.0 . -f docker/Dockerfile
}

function springboot-src-build()
{
    echo "springboot-src-build"
    start-app
    docker exec -it ${APP_NAME} bash -c "cd /home/springweb/ && ./gradlew build"
    stop-app 
}

function start-app()
{
    echo "start-app"
    docker run -it --name ${APP_NAME} -d --rm -p 8080:8080 -v $(pwd)/springweb:/home/springweb springbootapp:1.0
}

function stop-app()
{
    echo "stop-app"
    docker stop app-01
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

function restart()
{
    stop
    start
}

function deploy()
{
    docker-image-build
    springboot-src-build
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
    restart
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
