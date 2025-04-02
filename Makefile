# Compiler and Flags
CC = gcc
CFLAGS = -Wall -g

# Paths to wolfSSL
WOLFSSL_INC = /home/kor/Documents/wolfssl/
WOLFSSL_LIB = /home/kor/Documents/wolfssl/src/.libs

# Default: Linux system paths
WOLFSSL_INC_SYSTEM = /home/kor/Documents/wolfssl/
WOLFSSL_LIB_SYSTEM = /home/kor/Documents/wolfssl/src/.libs

# Detect macOS and set correct paths
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)  # macOS
    ifeq ($(shell arch), arm64)  # Apple Silicon (M1/M2/M3)
        WOLFSSL_INC_SYSTEM = /opt/homebrew/include
        WOLFSSL_LIB_SYSTEM = /opt/homebrew/lib
    else  # Intel Macs
        WOLFSSL_INC_SYSTEM = /usr/local/include
        WOLFSSL_LIB_SYSTEM = /usr/local/lib
    endif
endif


# Source and Executable
SRC = src/main.c
OBJ = $(SRC:.c=.o)
EXEC = ICIS_Encryption

MODE ?= custom

ifeq ($(MODE), custom)
    WOLFSSL_INC = $(WOLFSSL_INC_CUSTOM)
    WOLFSSL_LIB = $(WOLFSSL_LIB_CUSTOM)
else
    WOLFSSL_INC = $(WOLFSSL_INC_SYSTEM)
    WOLFSSL_LIB = $(WOLFSSL_LIB_SYSTEM)
endif


# wolfSSL Libraries
LIBS = -lwolfssl

# Compilation and Linking Rules
all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) -I$(WOLFSSL_INC) -L$(WOLFSSL_LIB) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -I$(WOLFSSL_INC) -c $< -o $@

clean:
	rm -f $(OBJ) $(EXEC)