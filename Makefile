DOCKER_RUN = docker run -it --rm \
	-e "http_proxy=$(http_proxy)" \
	-e "https_proxy=$(https_proxy)" \
	-e "HTTP_PROXY=$(HTTP_PROXY)" \
	-e "HTTPS_PROXY=$(HTTPS_PROXY)" \
	-v $(PWD):/usr/src

DOCKER_DAEMON = docker run -d \
	-e "http_proxy=$(http_proxy)" \
	-e "https_proxy=$(https_proxy)" \
	-e "HTTP_PROXY=$(HTTP_PROXY)" \
	-e "HTTPS_PROXY=$(HTTPS_PROXY)" \
	-v $(PWD):/usr/src

all: docker-image reconf module dist

# build docker image
docker-image:
	cd docker && make docker-image

# reconfigure sources
reconf:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie reconf

# compile library
module:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie make

# build distribution tarball
dist:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie make dist

package-deb:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie deb

# test agent keys with `zabbix_agentd -p`
test:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie test

# start a shell session in the docker container
shell:
	$(DOCKER_RUN) libzbxpython/build-debian-jessie /bin/bash

# start the Zabbix agent
agent:
	$(DOCKER_RUN) \
		--name zabbix_agent \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent

# start a shell session in the docker container with the Zabbix agent running
agent-shell:
	docker rm -f zabbix_agent || :
	$(DOCKER_DAEMON) \
		--name zabbix_agent \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent
	sleep 2
	docker exec -it zabbix_agent /bin/bash
	docker rm -f zabbix_agent

# run a benchmark in the docker container with the Zabbix agent running
agent-bench:
	docker rm -f zabbix_agent || :
	$(DOCKER_DAEMON) \
		--name zabbix_agent \
		-p 10050:10050 \
		libzbxpython/build-debian-jessie agent
	sleep 2
	docker exec -it zabbix_agent /entrypoint.sh bench
	docker rm -f zabbix_agent
