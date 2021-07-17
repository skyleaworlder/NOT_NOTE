# 指针作为返回值类型

当然是可以的，但是这很傻。除了分配内存之外，我也想不到为什么非要把 “指针类型” 当作返回值类型。

## 1. 返回局部变量（栈上）地址

首先是函数内定义局部变量，返回局部变量的地址：

```c
int* hello(int* a, int* b) {
    int c = *a + *b;
    int* p_c = &c;
    printf("p_c: %d / 0x%08x\n", *p_c, p_c);
    return p_c;
}
```

局部变量是栈上的，函数返回之后，虽然函数栈帧不会立刻清空，但是 `SP` 指针已经下降了。后续一旦在栈上分配了许多内存，那么 **原先的值所在位置** 就会被新的变量占据：

```c
int* res = hello(input1, input2);
// use arr to take up some memory,
// include p_c's value in function hello.
int arr[2000] = { 0 };
// if arr not printf, gcc might optimize/remove arr in memory
printf("arr: 0x%08x\n", arr);
// res is cleaned by arr[2000].
// res's value should be 3, but 0 now.
printf("res: %d / 0x%08x\n", *res, res);
```

返回局部变量的地址，有大病。

## 2. 返回堆上变量地址

这个是合理的，但是也多少沾点。`malloc` 和 `free` 不放在一起，很容易乱套，搞不好就 `double-free` 了。

```c
int* hello(int* a, int* b) {
    int* c = (int*)malloc(sizeof(int));
    *c = *a + *b;

    printf("c: %d / 0x%08x\n", *c, c);
    return c;
}
```

```c
int* res = hello(input1, input2);
// arr is on stack, while res is on heap
int arr[1000] = { 0 };
printf("arr: 0x%08x\n", arr);
printf("res: %d / 0x%08x\n", *res, res);
```

可以是可以，但也不太行。

## 3. 所以

还是把指针通过参数传递吧。这样是在外面调用方 `malloc`，也在外面的调用方 `free`。
