PYTHON_VERSION = 3.4

DOCKER_RUN = docker run -it --rm \
	-e "PYTHON_VERSION=$(PYTHON_VERSION)" \
	-e "http_proxy=$(http_proxy)" \
	-e "https_proxy=$(https_proxy)" \
	-e "no_proxy=$(no_proxy)" \
	-e "HTTP_PROXY=$(HTTP_PROXY)" \
	-e "HTTPS_PROXY=$(HTTPS_PROXY)" \
	-e "NO_PROXY=$(NO_PROXY)" \
	-v $(PWD):/usr/src

DOCKER_DAEMON = docker run -d \
	-e "PYTHON_VERSION=$(PYTHON_VERSION)" \
	-e "http_proxy=$(http_proxy)" \
	-e "https_proxy=$(https_proxy)" \
	-e "no_proxy=$(no_proxy)" \
	-e "HTTP_PROXY=$(HTTP_PROXY)" \
	-e "HTTPS_PROXY=$(HTTPS_PROXY)" \
	-e "NO_PROXY=$(NO_PROXY)" \
	-v $(PWD):/usr/src

all: docker-build

docker-image:
	docker build \
		--build-arg "http_proxy=$(http_proxy)" \
		--build-arg "https_proxy=$(https_proxy)" \
		--build-arg "no_proxy=$(no_proxy)" \
		--build-arg "HTTP_PROXY=$(HTTP_PROXY)" \
		--build-arg "HTTPS_PROXY=$(HTTPS_PROXY)" \
		--build-arg "NO_PROXY=$(NO_PROXY)" \
		-t libzbxpython/build-debian-jessie \
		.

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
