#include <stdio.h>
#include <stdlib.h>

int* hello(int* a, int* b) {
    int* c = (int*)malloc(sizeof(int));
    *c = *a + *b;

    printf("c: %d / 0x%08x\n", *c, c);
    return c;
}

// used as parameters | result
struct pr {
    int val;
};

struct pr* p_hello(struct pr* a, struct pr* b) {
    struct pr* c = (struct pr*)malloc(sizeof(struct pr));
    c->val = a->val + b->val;

    printf("pr: 0x%08x\n", c);
    return c;
}

int main() {
    // base type
    int a = 1, b = 2;
    int *input1 = &a, *input2 = &b;

    int* res = hello(input1, input2);

    // arr is on stack, while res is on heap
    int arr[1000] = { 0 };
    printf("arr: 0x%08x\n", arr);

    printf("res: %d / 0x%08x\n", *res, res);

    // struct type
    struct pr p_a, p_b;
    p_a.val = 1;
    p_b.val = 2;
    struct pr *p_input1 = &p_a, *p_input2 = &p_b;

    struct pr* p_res = p_hello(p_input1, p_input2);

    // arr1 is on stack, while res is on heap
    int arr1[1000] = { 0 };
    printf("arr1: 0x%08x\n", arr1);

    printf("p_res: %d / 0x%08x\n", *p_res, p_res);
}