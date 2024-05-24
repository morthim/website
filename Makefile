include .env

init-sandbox:
	docker run -d --name dev-ct alpine sleep infinity
	docker exec -it dev-ct ash

clean-sandbox:
	docker stop dev-ct && docker rm dev-ct

lint:
	docker run --rm -i ghcr.io/hadolint/hadolint < Dockerfile

build-dev:
	docker build \
	--build-arg img_ver=dev \
	--build-arg analytics_src=${A7S_SRC} \
	--build-arg analytics_id=${A7S_ID} \
	--no-cache \
	-t hugo-dev .

run-dev:
	docker run \
	-p 80:1313 \
	--name hugo-dev \
	-d hugo-dev

clean-dev:
	docker rm -f hugo-dev