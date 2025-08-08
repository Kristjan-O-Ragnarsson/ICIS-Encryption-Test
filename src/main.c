//
// Created by Kristján Ragnarsson on 27.3.2025.
//

#include "main.h"
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/chacha20_poly1305.h>


#ifdef __linux__
#include <sys/random.h>
#elif defined(__APPLE__)
#include <stdlib.h>
#endif

#define KEY_SIZE 32
#define NONCE_SIZE 12
#define TAG_SIZE 16

void generate_nonce(unsigned char *nonce) {
#ifdef __MACH__
    arc4random_buf(nonce, NONCE_SIZE);
#elif defined(__linux__)
    if (getrandom(nonce, NONCE_SIZE, 0) != NONCE_SIZE) {
        perror("getrandom");
        exit(EXIT_FAILURE);
    }
#endif
}

const unsigned char key[KEY_SIZE] = { /* 32-byte key */ };
unsigned char nonce[NONCE_SIZE] = { /* 12-byte nonce */ };
const unsigned char aad[] = "Example AAD";


void encrypt_chacha20_poly1305(const unsigned char *plaintext, int len,
                                unsigned char *ciphertext, unsigned char *tag, unsigned char *nonce) {
    wc_ChaCha20Poly1305_Encrypt(
        key, nonce, aad, strlen((char *)aad),
        plaintext, len, ciphertext, tag
    );
}

int decrypt_chacha20_poly1305(const unsigned char *ciphertext, int len,
                              unsigned char *plaintext, const unsigned char *tag, unsigned char *nonce) {
    return wc_ChaCha20Poly1305_Decrypt(
        key, nonce, aad, strlen((char *)aad),
        ciphertext, len, tag, plaintext
    );
}

void combine_message(
    const unsigned char *nonce, size_t nonce_len,
    const unsigned char *ciphertext, size_t text_len,
    const unsigned char *tag, size_t tag_len,
    unsigned char **output, size_t *output_len
) {
    // Calculate the total size needed
    *output_len = nonce_len + text_len + tag_len;
    *output = malloc(*output_len);
    if (!*output) {
        perror("malloc failed");
        exit(EXIT_FAILURE);
    }

    // Copy nonce, ciphertext, and tag into the output buffer
    memcpy(*output, nonce, nonce_len);
    memcpy(*output + nonce_len, ciphertext, text_len);
    memcpy(*output + nonce_len + text_len, tag, tag_len);
}

void split_message(
    const unsigned char *input, size_t input_len,
    unsigned char **nonce, unsigned char **ciphertext, size_t *ciphertext_len,
    unsigned char **tag
) {
    if (input_len < NONCE_SIZE + TAG_SIZE) {
        fprintf(stderr, "Error: Input buffer too small to contain nonce and tag\n");
        exit(EXIT_FAILURE);
    }

    *nonce = malloc(NONCE_SIZE);
    if (!*nonce) {
        perror("malloc failed");
        exit(EXIT_FAILURE);
    }
    memcpy(*nonce, input, NONCE_SIZE);


    *ciphertext_len = input_len - (NONCE_SIZE + TAG_SIZE);


    *ciphertext = malloc(*ciphertext_len);
    if (!*ciphertext) {
        perror("malloc failed");
        free(*nonce);
        exit(EXIT_FAILURE);
    }
    memcpy(*ciphertext, input + NONCE_SIZE, *ciphertext_len);




    *tag = malloc(TAG_SIZE);
    if (!*tag) {
        perror("malloc failed");
        free(*nonce);
        free(*ciphertext);
        exit(EXIT_FAILURE);
    }
    memcpy(*tag, input + NONCE_SIZE + *ciphertext_len, TAG_SIZE);
}



int main() {
    //const unsigned char plaintext[] = "Hello, wolfSSL!";
    char buffer[1024];
	const unsigned char *plaintext;
    unsigned char tag[TAG_SIZE];
    unsigned char *message;
    size_t message_len;
    size_t plaintext_len = 0;
    struct timespec start, end, start_decrypt, end_encrypt, end_random;

    timespec_get(&start, TIME_UTC);
    generate_nonce(nonce);

    timespec_get(&end_random, TIME_UTC);

    //unsigned char ciphertext[] = {0xd7, 0x62, 0x8b, 0xd2, 0x3a, 0x7d, 0x18, 0x0d, 0xf7, 0xd6, 0xf1, 0x2f, 0x20, 0x61, 0x29, 0x0d};
	if (fgets(buffer, sizeof(buffer), stdin) == NULL) {
          perror("fgets failed");
	} else{
          plaintext_len = strlen(buffer);
          #ifdef __MACH__
          printf("plaintext length: %zu\n", plaintext_len);
          #endif
          buffer[plaintext_len] = '\0';
          plaintext = (const unsigned char *)buffer;

    }
    fprintf(stderr, "plaintext is %s\n", plaintext);
    unsigned char ciphertext[plaintext_len];
    unsigned char decrypted[plaintext_len];

    encrypt_chacha20_poly1305(plaintext, plaintext_len, ciphertext, tag, nonce);
	#ifdef __MACH__
//    printf("Nonce: ");
//    for (size_t i = 0; i < sizeof(nonce); ++i) {
//      printf("%02x ", nonce[i]);
//    }
//    printf("\nCiphertext: ");
//    for (size_t i = 0; i < sizeof(ciphertext); i++) {
//        printf("%02x ", ciphertext[i]);
//    }
//	printf("\nTag: ");
//    for (size_t i = 0; i < sizeof(tag); i++) {
//      printf("%02x ", tag[i]);
//    }
//    printf("\n");
	#endif

    combine_message(nonce, sizeof(nonce), ciphertext, plaintext_len, tag, sizeof(tag), &message, &message_len);

	timespec_get(&end_encrypt, TIME_UTC);
    timespec_get(&start_decrypt, TIME_UTC);
	char arr[60];
    sprintf(arr, "./text/%zu.bin", plaintext_len);
    /*
    FILE *f = fopen(arr, "ab");  // "ab" = append binary
	if (!f) {
    	perror("fopen failed");
    	exit(1);
	}

	size_t written = fwrite(message, 1, message_len, f);
	if (written != message_len) {
    	perror("fwrite failed");
	}

	fclose(f);*/


    char buffer_two[1024];
    const unsigned char *data;
    //size_t ciphertext_len = 0;

   FILE *file = fopen(arr, "rb");
    if (!file) {
        perror("Failed to open file");
        return 1;
    }
    size_t bytes_read = fread(buffer_two, 1, sizeof(buffer_two), file);
    fclose(file);
   	buffer_two[bytes_read] = '\0';
    data = (const unsigned char *)buffer_two;



#ifdef __MACH__
//    printf("Message: ");
//    for (size_t i = 0; i < message_len; i++) {
//      printf("%02x ", message[i]);
//    }
//
//    printf("\n");
//    printf("Data: ");
//    for (size_t i = 0; i < bytes_read; i++) {
//      printf("%02x ", data[i]);
//    }
//
//    printf("\n");
#endif

    unsigned char *tag_t = NULL;
    unsigned char *nonce_t = NULL;
    unsigned char *ciphertext_t = NULL;
    size_t chipertext_len_t;
    split_message(data, bytes_read, &nonce_t, &ciphertext_t, &chipertext_len_t, &tag_t);

#ifdef __MACH__
//    printf("Nonce: ");
//    for (size_t i = 0; i < sizeof(nonce); ++i) {
//        printf("%02x ", nonce_t[i]);
//    }
//    printf("\nCiphertext: ");
//    for (size_t i = 0; i < sizeof(ciphertext); i++) {
//        printf("%02x ", ciphertext_t[i]);
//    }
//	printf("\nTag: ");
//    for (size_t i = 0; i < sizeof(tag); i++) {
//        printf("%02x ", tag_t[i]);
//    }
//    printf("\n");
#endif

    if (decrypt_chacha20_poly1305(ciphertext_t, chipertext_len_t, decrypted, tag_t, nonce_t) == 0) {
        decrypted[chipertext_len_t] = '\0'; // required for linux as memory can be initialized with data
        printf("Decrypted: %s\n", decrypted);

    } else {
        printf("Decryption failed!\n");
    }
	timespec_get(&end, TIME_UTC);
    printf("Encrypt/Decrytp/Random time: %ld\n", end.tv_nsec - start.tv_nsec);
    printf("Random time: %ld\n", end_random.tv_nsec - start.tv_nsec);
    printf("Encrypt time: %ld\n", end_encrypt.tv_nsec - end_random.tv_nsec);
    printf("Decrypt time: %ld\n", end.tv_nsec - start_decrypt.tv_nsec);

    return 0;
}