#include <stdio.h>

#define INTEGER int

#define HELLO_WORLD \
    printf("Hello World!\n")
#define MAX(x, y) ((x) > (y) ? (x) : (y))

#ifndef SUCCESS
    #define SUCCESS
    #define M 5
#endif

// #define FAILURE
#ifdef FAILURE
    #undef FAILURE
    #error Failure has defined
#endif

#if defined _FILE_DEFINED
    #define FILE_DEFINED_
#elif !defined(__cplusplus)
    #define nocplusplus__
#else
    #define HAHAHA
#endif

unsigned INTEGER g1 = 2;

INTEGER main() {
    HELLO_WORLD;
    printf("File: %s\n", __FILE__);
    printf("Date: %s\n", __DATE__);
    printf("Time: %s\n", __TIME__);
    printf("Line: %d\n", __LINE__);
    printf("Stdc: %d\n", __STDC__);
    printf("max(1,2): %d\n", MAX(1, 2));
    return 0;
}