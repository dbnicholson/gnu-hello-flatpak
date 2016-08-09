#!/bin/sh

FILE=org.gnu.hello.json
VERSION=2.10

APPID=`basename $FILE .json`

if [ x$TARGET != x`uname -p` -a ! -z "$TARGET" ]; then
	if [ ! -x qemu-static ]; then
		echo "QEmu static emulator missing as 'qemu-static' executable"
		exit 1
	fi

	ARCH_OPT="--arch=$TARGET"
	ARCH_EMU_OPT="--arch-emulator=`pwd`/qemu-static"
else
	TARGET=`uname -p`
fi

# Unset the --arch-emulator if flatpak doesn't support it
if [ ! -z "$ARCH_EMU_OPT" ] ; then
	flatpak-builder --help | grep -q arch-emulator || ARCH_EMU_OPT=""
fi

echo ========== Building $APPID ================
rm -rf app
flatpak-builder $ARCH_OPT $ARCH_EMU_OPT --ccache --require-changes --repo=hello-repo --subject="${APPID} ${VERSION}" ${EXPORT_ARGS-} app $FILE && \
flatpak build-bundle $ARCH_OPT hello-repo/ $APPID.$TARGET.xdgapp $APPID master
