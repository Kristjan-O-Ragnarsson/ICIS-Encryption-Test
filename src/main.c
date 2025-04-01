//
// Created by Kristján Ragnarsson on 27.3.2025.
//

#include "main.h"
#include <stdio.h>
#include <string.h>
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/chacha20_poly1305.h>

#define KEY_SIZE 32
#define NONCE_SIZE 12
#define TAG_SIZE 16

const unsigned char key[KEY_SIZE] = { /* 32-byte key */ };
const unsigned char nonce[NONCE_SIZE] = { /* 12-byte nonce */ };
const unsigned char aad[] = "Example AAD";


void encrypt_chacha20_poly1305(const unsigned char *plaintext, int len,
                                unsigned char *ciphertext, unsigned char *tag) {
    wc_ChaCha20Poly1305_Encrypt(
        key, nonce, aad, strlen((char *)aad),
        plaintext, len, ciphertext, tag
    );
}

int decrypt_chacha20_poly1305(const unsigned char *ciphertext, int len,
                              unsigned char *plaintext, const unsigned char *tag) {
    return wc_ChaCha20Poly1305_Decrypt(
        key, nonce, aad, strlen((char *)aad),
        ciphertext, len, tag, plaintext
    );
}


int main() {
    const unsigned char plaintext[] = "Hello, wolfSSL!";
    unsigned char ciphertext[sizeof(plaintext)];
    unsigned char decrypted[sizeof(plaintext)];
    unsigned char tag[TAG_SIZE];

    //unsigned char ciphertext[] = {0xd7, 0x62, 0x8b, 0xd2, 0x3a, 0x7d, 0x18, 0x0d, 0xf7, 0xd6, 0xf1, 0x2f, 0x20, 0x61, 0x29, 0x0d};

    encrypt_chacha20_poly1305(plaintext, sizeof(plaintext), ciphertext, tag);

    printf("Nonce: ")
    for (size_t i = 0; i < sizeof(nonce); ++i) {
      printf("%02x ", nonce[i]);
    }
    printf("Ciphertext: ");
    for (size_t i = 0; i < sizeof(ciphertext); i++) {
        printf("%02x ", ciphertext[i]);
    }
    for (size_t i = 0; i < sizeof(tag); i++) {
      printf("%02x ", tag[i]);
    }
    printf("\n");

    if (decrypt_chacha20_poly1305(ciphertext, sizeof(ciphertext), decrypted, tag) == 0) {
        printf("Decrypted: %s\n", decrypted);
    } else {
        printf("Decryption failed!\n");
    }

    return 0;
}