build:
	docker build -t theculliganman/folding-at-home:latest .

run:
	$(MAKE) build
	$(MAKE) stop || true
	docker run \
		--rm \
		-d \
		--gpus all \
		--name folding-at-home \
		-p 7396:7396 \
		theculliganman/folding-at-home:latest

logs:
	docker logs -f --tail=1000 folding-at-home

stop:
	docker stop folding-at-home

clean: stop
	docker rmi folding-at-home