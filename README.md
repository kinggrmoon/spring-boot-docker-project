# spring-boot-docker-project


## Info

- springboot 빌드 환경을 docker Centainer로 구성한다.
- sprignboot의 소스 빌드는 gradle을 통해 빌드를 진행한다.
- 프로젝트는 nginx의 LoadBalance(RB) 구성을 통해 고가용성을 유지 한다
- 소스 업데이트시 무중단 배포를 구성한다.

## RUN Environment
- HOST: Git, Docker, Docker-compose
- Build Contaner, WEBAPP Contaner: 
  - oepnjdk:16
  - openjdk version "16.0.2" 2021-07-20
  - gradle-7.1
- Nginx Contaner:
  - jwilder/nginx-proxy:latest
  

## Script Info
> 소스코드 다운로드 및 Project 시작하기     

    $ git clone https://github.com/kinggrmoon/spring-boot-docker-project.git
    $ cd spring-boot-docker-project
    $ ./script/springweb-boot-docker-project.sh start

> ./script/springweb-boot-docker-project.sh 설명   

    $ Usage: ./script/springweb-boot-docker-project.sh {start | stop | restart | status | deploy | scaleout | scalein}

- start: 프로젝트 사작(소스 빌드, webapp 이미지 생성 및 구동)
- stop: 프로젝트 종료(리소스 전체 삭제)
- restart: 프로젝트 종료후 재시작
- status: 컨테이너 상태 출력
- deploy: 소스 빌드 및 재배포(무중단)
- scaleout: webapp Scale out (+1)
- scalein: webapp Scale in (-1)


## use commend

ex>

    $ docker exec -it {ContainerNAME} bash -c "nginx -s reload"

    $ docker ps | awk -F" " '{print}' | awk " NR > 1"

    $ docker ps |grep ${ContainerID} | awk '{print $1" "$12}'

    $ docker ps | awk -F" " '{print $1}' | awk " NR > 1" >> RunContainerID

    $ cat RunContainerName| tail -n 1

    $ cat RunContainerName| head -n 1

## 참고
---
