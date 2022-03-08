// Giulia Giozza, 2022

// code shared by M Johann

#ifndef hash_h
#define hash_h

#include <stdio.h>

#define HASH_SIZE 997 // closest prime number to 1000 - ensures a randomized distribution

typedef struct hash_node {
    int type;
    char *text;
    struct hash_node * next;
} HASH_NODE;

void hashInit(void);
int hashAddress(char *text);
HASH_NODE *hashFind(char *text);
HASH_NODE *hashInsert(char *text, int type);
void hashPrint(void);

#endif