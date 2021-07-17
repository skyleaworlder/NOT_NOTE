#include "header.h"

// s1 is a static variable in static.c
// cannot use extern to locate static variable s1's value & address
// extern will not raise error, but when s1 is using,
// "undefined reference to 's1'" will be returned.
// extern int s1;

static int s2 = 2;

// defined in static.c
// int e1 = 1;
// using "extern" to point to e1 that cannot be initialized here
// you also can use "int e1", but "extern int e1" might be much better
// int e1;
extern int e1;

// global variable e2
int e2 = 2;

int test() {
    printf("This is function: test\n");
    // cannot use s1(static int)
    // printf("%d\n", s1);
    printf("%d\n", s2);

    printf("%d\n", e1);

    // l1's domain is function test()
    // and l1 needn't multi-initialization process
    static int l1 = 1;
    printf("%d\n", l1++);
    return 0;
}

int test2() {
    printf("This is function: test2\n");
    static int l1;

    // l1 is different from "l1 in function test()"
    // l1 is initialized as default value of integer type: 0
    printf("%d\n", l1);
    return 0;
}