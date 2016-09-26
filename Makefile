PYTHON_VERSION = 3.4

DOCKER_RUN = docker run -it --rm \
	-e "PYTHON_VERSION=$(PYTHON_VERSION)" \
	-v $(PWD):/usr/src

DOCKER_DAEMON = docker run -d \
	-e "PYTHON_VERSION=$(PYTHON_VERSION)" \
	-v $(PWD):/usr/src

all: docker-build

docker-image:
	docker build -t libzbxpython/build-debian-jessie .

docker-build:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie make

docker-release:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie release

docker-test:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie test

docker-shell:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie /bin/bash

docker-agent:
	$(DOCKER_RUN) \
		--name zabbix_agent \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent

docker-agent-shell:
	docker rm -f zabbix_agent || :
	$(DOCKER_DAEMON) \
		--name zabbix_agent \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent
	sleep 2
	docker exec -it zabbix_agent /bin/bash
	docker rm -f zabbix_agent
