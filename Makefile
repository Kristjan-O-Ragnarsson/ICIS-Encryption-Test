# Compiler and Flags
CC = gcc
CFLAGS = -Wall -g

# Paths to wolfSSL
WOLFSSL_INC = /home/kor/Documents/wolfssl/wolfssl
WOLFSSL_LIB = /home/kor/Documents/wolfssl/src/.libs

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