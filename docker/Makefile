all: docker-image

docker-image: 
	docker build \
		-f build-debian-jessie.Dockerfile \
		--build-arg "http_proxy=$(http_proxy)" \
		--build-arg "https_proxy=$(https_proxy)" \
		--build-arg "no_proxy=$(no_proxy)" \
		--build-arg "HTTP_PROXY=$(HTTP_PROXY)" \
		--build-arg "HTTPS_PROXY=$(HTTPS_PROXY)" \
		--build-arg "NO_PROXY=$(NO_PROXY)" \
		-t libzbxpython/build-debian-jessie \
		.

.PHONY: docker-image
