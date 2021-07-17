#include "header.h"

// static variable s1 can only be used in static.c
static int s1 = 1;

// s2 is a static variable in another.c
// cannot use extern to locate static variable s2's value & address
// extern will not raise error, but when s2 is using,
// "undefined reference to 's2'" will be returned.
// extern int s2;

int e1 = 1;

extern int e2;

// using extern to get address of function "test"
// test is in another.c
// even it's not defined in header.h
// it can be exported to static.c by "extern" still
extern int test();
extern int test2();
extern int test3();

int main() {
    printf("%d\n", s1);
    // printf("%d\n", s2);
    printf("%d\n", e1);
    printf("%d\n", e2);

    test();
    test();
    test2();
    test3();
}