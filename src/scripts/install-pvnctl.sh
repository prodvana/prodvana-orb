#!/bin/bash
set -euxo pipefail

RELEASE="latest"
if [[ ${PARAM_VERSION} == "latest" ]]; then
	VERSION=$(curl -s "https://api.github.com/repos/prodvana/pvnctl/releases/${RELEASE}" | jq -r ".tag_name")
else
	VERSION=${PARAM_VERSION}
fi

if [[ ${VERSION} == v* ]]; then
	# Strip leading v
	VERSION="${VERSION#?}"
fi

case $(uname) in
Linux) PLATFORM="linux" ;;
Darwin) PLATFORM="darwin" ;;
*)
	echo "unsupported platform"
	exit 1
	;;
esac

case $(uname -m) in
x86_64) ARCH="amd64" ;;
i386) ARCH="386" ;;
arm64) ARCH="arm64" ;;
aarch64) ARCH="arm64" ;;
*)
	echo "unsupported architecture"
	exit 1
	;;
esac

ARCHIVE_NAME="pvnctl_${VERSION}_${PLATFORM}_${ARCH}.tar.gz"

curl -Ls -o checksums.txt "https://github.com/prodvana/pvnctl/releases/download/v${VERSION}/checksums.txt"
curl -Ls -o "${ARCHIVE_NAME}" "https://github.com/prodvana/pvnctl/releases/download/v${VERSION}/${ARCHIVE_NAME}"

# validate checksum
sha256sum --check --ignore-missing < checksums.txt

tar xf "${ARCHIVE_NAME}"
rm "${ARCHIVE_NAME}" checksums.txt

[[ -w /usr/local/bin ]] && SUDO="" || SUDO=sudo

${SUDO} chmod +x ./pvnctl
${SUDO} mv ./pvnctl /usr/local/bin/pvnctl
