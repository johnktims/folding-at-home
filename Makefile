TAG := latest
CONTAINER_NAME := folding-at-home

build:
	docker build -t theculliganman/folding-at-home:${TAG} .

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
		theculliganman/folding-at-home:${TAG}

logs:
	docker logs -f --tail=1000 

stop:
	docker stop ${CONTAINER_NAME}

clean: stop
	docker rmi ${CONTAINER_NAME}
