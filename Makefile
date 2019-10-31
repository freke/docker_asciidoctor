all: docker

docker:
	docker build --no-cache --force-rm --pull --network="host" -t freke/docker_asciidoctor .
