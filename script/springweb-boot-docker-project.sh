#!/bin/bash

BUILD_APP_NAME="build-app"
APP_NAME="app-01"
PROJECT="project"

PWD=$(pwd)
echo ${PWD}

## src build
function springboot-src-build()
{
  echo "======springboot-src-build======"
  docker build --tag springbootbuildapp:1.0 . -f docker/Dockerfile_Build
  docker run -it --name ${BUILD_APP_NAME} -d --rm -v ${PWD}/springweb:/home/springweb springbootbuildapp:1.0
  docker exec -it ${BUILD_APP_NAME} bash -c "cd /home/springweb/ && ./gradlew build"
  docker stop ${BUILD_APP_NAME}
}

## app image build
function springboot-app-build()
{
  docker build --tag springbootwebapp:1.0 . -f docker/Dockerfile 
}

function start()
{
    echo "======start======"

    echo "step1: source build"
    springboot-src-build

    echo "step2: docker image build"
    springboot-app-build
   
    echo "step3: start containers"
    #docker run -it --name ${APP_NAME} -d --rm -p 8080:8080 springbootwebapp:1.0
    docker-compose -p ${PROJECT} -f docker/docker-compose.yml up -d
    #docker ps | grep ${PROJECT}_group | awk '{print $1}' | awk " NR > 1" > ${PWD}/RunContainerID
    #docker ps | grep ${PROJECT}_nginx | awk '{print $1" "$14}' > ${PWD}/RunContainerID-Name
    docker ps | grep ${PROJECT}_group | awk '{print $1}' > ${PWD}/RunContainerID
    docker ps | grep ${PROJECT}_group | awk -F"tcp" '{print $2}' > ${PWD}/RunContainerName
    sed -i '' 's/^ *//' ${PWD}/RunContainerName

    echo "step4: nginx config update && reload"
    sed -i '' "/server ${PROJECT}_/d" nginx/nginx.conf
    while read name; do 
      sed -i '' "s,RunServer,RunServer\nserver ${name}:8080;,g" ${PWD}/nginx/nginx.conf
    done < ${PWD}/RunContainerName

    docker exec -it ${PROJECT}_nginx_proxy_1 bash -c "nginx -s reload"
}

function stop()
{
    echo "======project-all-stop======"
    docker-compose -p ${PROJECT} -f docker/docker-compose.yml stop
    docker-compose -p ${PROJECT} -f docker/docker-compose.yml rm -f
    docker network prune -f
    rm -rf ${PWD}/RunContainerID ${PWD}/RunContainerName 
}

function deploy()
{
  springboot-src-build
  springboot-app-build  
}

function status()
{
    docker ps |grep ${PROJECT}
}

function scaleout()
{
    echo "======scaleout======"
    echo "step1: current RunServer check"
    RunContainerCount=$(cat ${PWD}/RunContainerID | wc -l)
    #echo ${RunContainerCount}
    #echo $((${RunContainerCount}+1))
    
    echo "step2: scaleout"
    docker-compose -p ${PROJECT} -f docker/docker-compose.yml up -d --scale group01_app=$((${RunContainerCount}+1))
    docker ps | grep ${PROJECT}_group | awk '{print $1}' > ${PWD}/RunContainerID
    docker ps | grep ${PROJECT}_group | awk -F"tcp" '{print $2}' > ${PWD}/RunContainerName
    sed -i '' 's/^ *//' ${PWD}/RunContainerName
    
    echo "step3: nginx config update && reload"
    sed -i '' "/server ${PROJECT}_/d" nginx/nginx.conf
    
    while read name; do 
      sed -i '' "s,RunServer,RunServer\nserver ${name}:8080;,g" nginx/nginx.conf
    done < ${PWD}/RunContainerName

    #sed -i '' "s,RunServer,RunServer\nserver ${PROJECT}_group01_app_add,g" nginx/nginx.conf  
    docker exec -it ${PROJECT}_nginx_proxy_1 bash -c "nginx -s reload"
}

function scalein()
{
    echo "======scalein======"
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  project-stop)
    project-stop
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
  scaleout)
    scaleout
    ;;
  scalein)
    scalein
    ;;
*)
  echo "Usage: $0 {start | stop | restart | status | deploy | scaleout | scalein}"
esac
exit 0
