#!/bin/bash

cd wolfssl || exit

if [[ -e "$(pwd)/user_settings.h" ]] ; then
  echo "user_settings.h Already exists"
else
  #echo "WGET"
  wget https://gist.githubusercontent.com/Kristjan-O-Ragnarsson/9283c795ca88445873888cac88040d37/raw/08f252965a0ad107c2399f6d3fc7dbeaa4f5ea13/user_settings.h
fi

if [[ $(uname -m) == "aarch64" ]] ; then # raspberry pi 4: aarch64
  #echo "Config"
  export CFLAGS="-Os -flto -fvisibility=hidden -DWOLFSSL_USER_SETTINGS_FILE='\"user_settings.h\"'"
  export LDFLAGS="-flto"
  ./configure \
    --host=aarch64-linux-gnu \
    --enable-static \
    --disable-shared \
    --disable-crypttests \
    --disable-examples \
    --disable-benchmark \
    --disable-certgen \
    --disable-keygen \
    --disable-opensslextra

  make
elif [[ $(uname -m) == "x86_64" ]] ; then
  export CFLAGS="-Os -flto -fvisibility=hidden -DWOLFSSL_USER_SETTINGS_FILE='\"user_settings.h\"'"
  export LDFLAGS="-flto"
  ./configure \
    --enable-static \
    --disable-shared \
    --disable-crypttests \
    --disable-examples \
    --disable-benchmark \
    --disable-certgen \
    --disable-keygen \
    --disable-opensslextra
  make
else
  echo "Figure out how to work on x86_64"
fi


