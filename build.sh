#!/bin/sh

FILE=org.gnu.hello.json
VERSION=2.10

APPID=`basename $FILE .json`

if [ x$TARGET != x`uname -p` -a ! -z "$TARGET" ]; then
	ARCH_OPT="--arch=$TARGET"
else
	TARGET=`uname -p`
fi

echo ========== Building $APPID ================
rm -rf app
flatpak-builder $ARCH_OPT --ccache --require-changes --repo=hello-repo --subject="${APPID} ${VERSION}" ${EXPORT_ARGS-} app $FILE && \
flatpak build-bundle $ARCH_OPT hello-repo/ $APPID-$(VERSION).$TARGET.xdgapp $APPID master
