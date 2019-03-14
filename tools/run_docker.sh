#!/bin/bash

set -e

# TODO(oschaaf): pull this sha
ENVOY_BUILD_SHA=b3995b7c5e3846f80f6f09436043ec4c8c8f762a

# We run as root and later drop permissions. This is required to setup the USER
# in useradd below, which is need for correct Python execution in the Docker
# environment.
USER=root
USER_GROUP=root

[[ -z "${IMAGE_NAME}" ]] && IMAGE_NAME="envoyproxy/envoy-build-ubuntu"
# The IMAGE_ID defaults to the CI hash but can be set to an arbitrary image ID (found with 'docker
# images').
[[ -z "${IMAGE_ID}" ]] && IMAGE_ID="${ENVOY_BUILD_SHA}"
[[ -z "${ENVOY_DOCKER_BUILD_DIR}" ]] && ENVOY_DOCKER_BUILD_DIR=/tmp/envoy-docker-build

[[ -f .git ]] && [[ ! -d .git ]] && GIT_VOLUME_OPTION="-v $(git rev-parse --git-common-dir):$(git rev-parse --git-common-dir)"

mkdir -p "${ENVOY_DOCKER_BUILD_DIR}"
# Since we specify an explicit hash, docker-run will pull from the remote repo if missing.
docker run --rm -t -i -e HTTP_PROXY=${http_proxy} -e HTTPS_PROXY=${https_proxy} \
-u "${USER}":"${USER_GROUP}" -v "${ENVOY_DOCKER_BUILD_DIR}":/build ${GIT_VOLUME_OPTION} \
-v "$PWD":/source -e NUM_CPUS --cap-add SYS_PTRACE --cap-add NET_RAW --cap-add NET_ADMIN "${IMAGE_NAME}":"${IMAGE_ID}" \
/bin/bash -lc "groupadd --gid $(id -g) -f envoygroup && useradd -o --uid $(id -u) --gid $(id -g) --no-create-home \
  --home-dir /source envoybuild && usermod -a -G pcap envoybuild && su envoybuild -c \"cd source && pwd && $*\""