# spring-boot-docker-project



docker exec -it project_nginx_proxy_1 bash -c "nginx -s reload"

docker ps | awk -F" " '{print}' | awk " NR > 1"

docker ps |grep 271996a68fbb | awk '{print $1" "$12}'

docker ps | awk -F" " '{print $1}' | awk " NR > 1" >> RunContainerID-Name


cat RunContainerName| tail -n 1

cat RunContainerName| head -n 1