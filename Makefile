IMAGE?=cloud-ready-flask:dev
PROD_IMAGE?=cloud-ready-flask:prod

.PHONY: build run-3000 run-9000 stop-ports clean build-prod run-prod

build:
	@echo "Building $(IMAGE)"
	docker build -t $(IMAGE) .

run-3000: build
	@echo "Running on host port 3000 -> container 5000"
	docker run --rm -p 3000:5000 $(IMAGE)

run-9000: build
	@echo "Running on host port 9000 -> container 5000"
	docker run --rm -p 9000:5000 $(IMAGE)

stop-ports:
	@echo "Stopping containers bound to 5000/5001/8080/3000/9000"
	-@docker ps --format '{{.ID}} {{.Ports}}' | grep -E '0.0.0.0:(5000|5001|8080|3000|9000)' | awk '{print $$1}' | xargs -r docker rm -f

clean:
	@echo "Removing image $(IMAGE)"
	-@docker rmi $(IMAGE)

build-prod:
	@echo "Building $(PROD_IMAGE) with Dockerfile.multistage"
	docker build -t $(PROD_IMAGE) -f Dockerfile.multistage .

run-prod: build-prod
	@echo "Running prod image on host port 80 -> container 80"
	docker run --rm -p 80:80 $(PROD_IMAGE)