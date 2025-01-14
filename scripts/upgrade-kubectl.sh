#!/bin/bash
set -eo pipefail

ARCH=amd64

VERSION=${1:?"usage: upgrade-kubectl <kubernetes_version>"}

LATEST_MINOR_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases?per_page=100 | jq -r 'map(.tag_name) | .[]' | grep -E -e "^v?$VERSION.[0-9]+\$" | sort -rV | head -n 1) || (echo "No revision found" && exit 1)

TMP=$(mktemp)

echo "Downloading kubectl ${LATEST_MINOR_VERSION}"
# trap "rm $TMP" EXIT SIGINT
curl -L https://dl.k8s.io/release/${LATEST_MINOR_VERSION}/bin/linux/$ARCH/kubectl > $TMP

echo "Downloading kubectl ${LATEST_MINOR_VERSION} signature"
trap "rm $TMP.sha256" EXIT SIGINT
curl -L https://dl.k8s.io/release/${LATEST_MINOR_VERSION}/bin/linux/$ARCH/kubectl.sha256 > $TMP.sha256

echo "Comparing signatures"
echo "$(cat $TMP.sha256) $TMP" | sha256sum --check

chmod +x $TMP
sudo mv $TMP `which kubectl`
