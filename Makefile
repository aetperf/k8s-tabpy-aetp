EDITOR=vim

all: build

build:
	docker build -t aetp/k8s-tabpy-aetp:release .

run: build
	docker run -ti -p 9004 aetp/k8s-tabpy-aetp:release 


clean:
	docker system prune
	
prune:
	docker system prune -f

exec:
	docker exec -ti `docker ps | grep k8s-tabpy-aetp:release |head -1 | awk -e '{print $$1}'` /bin/bash


stop:
	docker stop `docker ps | grep k8s-tabpy-aetp:release |head -1| awk -e '{print $$1}'`

