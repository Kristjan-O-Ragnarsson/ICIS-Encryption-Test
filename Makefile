# Compiler and Flags
CC = gcc
CFLAGS = -Wall -g


# Mode selection: 'custom' uses a local build, 'system' uses installed WolfSSL
MODE ?= system

ifeq ($(MODE), custom)
    WOLFSSL_INC = /home/kor/Documents/wolfssl/
    WOLFSSL_LIB = /home/kor/Documents/wolfssl/src/.libs
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S), Darwin)
        WOLFSSL_INC = /opt/homebrew/include
        WOLFSSL_LIB = /opt/homebrew/lib
    else
        WOLFSSL_INC = /usr/include
        WOLFSSL_LIB = /usr/lib
    endif
endif


# Source and Executable
SRC = src/main.c
OBJ = $(SRC:.c=.o)
EXEC = ICIS_Encryption

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