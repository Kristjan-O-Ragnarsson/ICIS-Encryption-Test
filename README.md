# ICIS Encryption Test

A simple project to test the performance of ChaCha20-Poly1305 encryption using WolfSSL on a Raspberry Pi.

## Dependencies

This project requires:
- `linux-perf` 
- `WolfSSL`

  
It has been tested on:
- Raspberry Pi running Raspberry Pi OS
- macOS (M1 Pro) - note that the macOS version is for development only and does not support performance testing.

## Installation

The Makefile assumes incorrect paths when using `MODE=custom`. It's recommended to use:

```bash
make MODE=system
```

## Testing

A test script (test.sh) is provided to benchmark performance using `perf`. It is designed for Raspberry Pi OS and assumes it’s being run on a Raspberry Pi.

```bash
./test.sh
```


# NAME ??

is used to test encryption performance of ChaCha20-Poly1305 implementation in WolfSSl
* Results??  

## Installation

This project requires:
- `linux-perf`
- `WolfSSL`

### Building WolfSSL

Requirements 
- `git`
- ``make``
- ``autoconf``
- ``libtool``

```shell
git submodulte init

git submodule update

cd wolfssl

git checkout 1c56a2674a5ef51c
```
optional: remove unused functionality
```shell
wget
```

```shell


./configure

make
```

## Usage
```shell
./test.sh
```
or
```shell
 perf stat ./ICIS_Encryption < "./text/[28,56,112,224].txt"
 
 /usr/bin/time -v ./ICIS_Encryption < ./text[28,56,112,224].txt
```




Tested on ubuntu and raspbian


