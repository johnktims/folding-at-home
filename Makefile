TAG := latest
IMAGE_NAME := theculliganman/folding-at-home
CONTAINER_NAME := folding-at-home

build:
	docker build -t ${IMAGE_NAME}:${TAG} .

build:
	docker push -t ${IMAGE_NAME}:${TAG}

run:
	$(MAKE) build
	$(MAKE) stop || true
	docker run \
		--rm \
		-d \
		--gpus all \
		--name ${CONTAINER_NAME} \
		-p 7396:7396 \
		-v $(PWD)/workdir:/usr/src/app \
		${IMAGE_NAME}:${TAG}

logs:
	docker logs -f --tail=1000 ${CONTAINER_NAME}

stop:
	docker stop ${CONTAINER_NAME}

clean: stop
	docker rmi ${CONTAINER_NAME}

exec:
	docker exec -it ${CONTAINER_NAME} bash