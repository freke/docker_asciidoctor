all: docker

docker:
	docker build --force-rm --pull --network="host" -t freke/docker_asciidoctor .
