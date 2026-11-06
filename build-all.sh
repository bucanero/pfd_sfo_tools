#!/bin/sh
# Cross-compile pfdtool and sfopatcher for every supported platform.
#
# Requires only zig and make.
# Output: build/<platform>/{pfdtool,sfopatcher}[.exe] plus the .conf files pfdtool needs.
#
# Usage: ./build-all.sh [platform...]    (default: all platforms)

set -e
cd "$(dirname "$0")"

# platform-name  zig-target  exe-suffix
PLATFORMS="
windows-amd64  x86_64-windows-gnu   .exe
windows-arm64  aarch64-windows-gnu  .exe
linux-amd64    x86_64-linux-musl
linux-arm64    aarch64-linux-musl
macos-amd64    x86_64-macos
macos-arm64    aarch64-macos
"

if command -v zig >/dev/null 2>&1; then
	ZIG=${ZIG:-zig}
else
	ZIG=${ZIG:-"python3 -m ziglang"}
	$ZIG version >/dev/null 2>&1 || { echo "zig not found" >&2; exit 1; }
fi

want="$*"
echo "$PLATFORMS" | while read -r name target ext; do
	[ -n "$name" ] || continue
	if [ -n "$want" ] && ! echo " $want " | grep -q " $name "; then continue; fi

	echo "==> $name ($target)"
	out="$PWD/build/$name"
	mkdir -p "$out"
	for tool in pfdtool sfopatcher; do
		make -C "$tool/src" -s CC="$ZIG cc -target $target" OPT="-O2" LDFLAGS="-s" EXT="$ext" \
			BUILD="$out" OBJDIR="$PWD/build/obj/$name/$tool" >/dev/null
	done
	cp pfdtool/bin/*.conf "$out/"
done

echo "Done. Binaries are in build/"
