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
