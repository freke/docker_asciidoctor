DOCKER=podman

ifeq (, $(shell which $(DOCKER)))
	DOCKER=docker
endif

all: docker

docker:
	$(DOCKER) build --no-cache --force-rm --pull --network="host" -t freke/docker_asciidoctor .
