#include <stdio.h>
#include <stdlib.h>

int* hello(int* a, int* b) {
    int c = *a + *b;
    int* p_c = &c;
    printf("p_c: %d / 0x%08x\n", *p_c, p_c);
    return p_c;
}

// used as parameters | result
struct pr {
    char magic;
    int val;
};

struct pr* p_hello(struct pr* a, struct pr* b) {
    struct pr c;
    struct pr* p_c = &c;
    c.val = a->val + b->val;

    printf("pr: 0x%08x\n", &c);
    return p_c;
}

int main() {
    // base type
    int a = 1, b = 2;
    int *input1 = &a, *input2 = &b;

    int* res = hello(input1, input2);

    // use arr to take up some memory,
    // include p_c's value in function hello.
    int arr[2000] = { 0 };
    // if arr not printf, gcc might optimize/remove arr in memory
    printf("arr: 0x%08x\n", arr);

    // res is cleaned by arr[2000].
    // res's value should be 3, but 0 now.
    printf("res: %d / 0x%08x\n", *res, res);

    // struct type
    struct pr p_a, p_b;
    p_a.val = 1;
    p_b.val = 2;
    struct pr *p_input1 = &p_a, *p_input2 = &p_b;

    struct pr* p_res = p_hello(p_input1, p_input2);

    int arr1[2000] = { 0 };
    // if arr1 not printf, gcc might optimize/remove arr in memory.
    printf("arr1: 0x%08x\n", arr1);

    // p_res->val is 0 now, instead of 3.
    printf("p_res: %d / 0x%08x\n", p_res->val, p_res);
}