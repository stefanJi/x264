#! /usr/bin/env bash
# ndk version: 20.0.5594570
# cross compile x264 for android

NDK=$ANDROID_NDK_ROOT
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
API=23

function build_android() {
  PREFIX=$(pwd)/android/$CPU
  echo "Compiling x264 for $CPU to $PREFIX"
  export CC=$CC
  export CXX=$CXX

  ./configure \
    --prefix="$PREFIX" \
    --disable-cli \
    --enable-static \
    --enable-strip \
    --enable-pic \
    --disable-asm \
    --cross-prefix="$CROSS_PREFIX" \
    --host="$HOST" \
    --sysroot="$TOOLCHAIN"/sysroot \
    --extra-cflags="$OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" || exit 1

  make clean
  make
  make install
  echo "The Compilation of x264 for $CPU is completed: $PREFIX"
}

#armv8-a
HOST=aarch64-linux
ARCH=arm64
CPU=armv8-a
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
OPTIMIZE_CFLAGS="-march=$CPU -O2"
build_android

#armv7-a
HOST=arm-linux
ARCH=arm
CPU=armv7-a
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
OPTIMIZE_CFLAGS="-march=armv7-a -O2 -mfloat-abi=softfp -mfpu=neon"
build_android

#x86
HOST=i686-linux
ARCH=x86
CPU=x86
CC=$TOOLCHAIN/bin/i686-linux-android$API-clang
CXX=$TOOLCHAIN/bin/i686-linux-android$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
OPTIMIZE_CFLAGS="-march=i686 -O2 -mtune=intel -mssse3 -mfpmath=sse -m32"
build_android

#x86_64
HOST=x86_64-linux
ARCH=x86_64
CPU=x86-64
CC=$TOOLCHAIN/bin/x86_64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/x86_64-linux-android$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
OPTIMIZE_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 -mtune=intel"
build_android
