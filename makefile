-include .env

LATEST_TAG ?= latest
IMAGE_NAME=wax-local
DOCKER_REGISTRY=eoscostarica506
VERSION ?= $(shell git rev-parse --short HEAD)

run: ##@devops Run docker image
run:
	@docker run -dp 8888:8888 $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG)

build-docker: ##@devops Build docker image
build-docker: ./Dockerfile
	@echo "Building docker container ..."
	@docker pull $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG) || true
	@docker build \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG) \
		--build-arg testnet_eosio_private_key="$(TESTNET_EOSIO_PRIVATE_KEY)" \
		--build-arg testnet_eosio_public_key="$(TESTNET_EOSIO_PUBLIC_KEY)" \
		.

pull-docker: ##@devops Pull docker image
pull-docker:
	@echo "Building docker container ..."
	@docker pull $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG) || true

push-image: ##@devops Push freshly built image and tag with release or latest tag
push-image:
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG)