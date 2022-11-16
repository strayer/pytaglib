#!/usr/bin/env bash

download_taglib() {
  yum install wget -y || true

  wget https://taglib.org/releases/taglib-1.13.tar.gz
  echo '58f08b4db3dc31ed152c04896ee9172d22052bc7ef12888028c01d8b1d60ade0  taglib-1.13.tar.gz' > CHECKSUM
  sha256sum -c CHECKSUM || shasum -c CHECKSUM
  tar xf taglib-1.13.tar.gz
  mv taglib-1.13 taglib-source
}

cmake_linux() {
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON .
}

cmake_macos() {
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=arm64\;x86_64 .
}

if [ ! -e taglib-source ]; then
  download_taglib
fi

cd taglib-source
if [[ "$OSTYPE" == "darwin"* ]]; then
  cmake_macos
else
  cmake_linux
fi
make
make install
