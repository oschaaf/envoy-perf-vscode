set -e
set -x
set -e

docker login
SOURCE_IMAGE="envoyproxy/nighthawk-dev:latest"
PUSH_IMAGE="oschaaf/nighthawk-dev:latest"
docker tag "${SOURCE_IMAGE}" "${PUSH_IMAGE}"
docker push "${PUSH_IMAGE}"
