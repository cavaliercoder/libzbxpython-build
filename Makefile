DOCKER_RUN = docker run -it --rm \
	-v $(PWD):/usr/src

all: docker-build

docker-image:
	docker build -t libzbxpython/build-debian-jessie .

docker-build:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie make

docker-release:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie release

docker-shell:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie /bin/bash

docker-agent:
	$(DOCKER_RUN) \
		--name zabbix_agent \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent

docker-agent-shell:
	docker rm -f zabbix_agent || :
	docker run \
		--name zabbix_agent \
		-d \
		-v $(PWD):/usr/src \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent
	sleep 2
	docker exec -it zabbix_agent /bin/bash
	docker rm -f zabbix_agent
