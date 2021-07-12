#include <stdio.h>
#include <stdlib.h>

// initialized global variables
// .data segment
int g1 = 0;
int g2 = 0;
int g3 = 0;

// un-initialized global variables
// .bss
int bss1;
int bss2;
int bss3;

int max(int i)
{
    // static variables
    // .data segment
    static int n1_max = 0;
    static int n2_max;
    static int n3_max = 0;

    // dynamic/automatic variables
    // .stack
    int m1 = 0;
    int m2;
    int m3 = 0;
    int *p1_max;
    int *p2_max;
    int *p3_max;

    p1_max = (int*)malloc(10);
    p2_max = (int*)malloc(sizeof(int));
    p3_max = (int*)malloc(5);

    printf("打印 max 程序地址\n");
    printf("0x%08x\n", max);
    printf("打印 max 函数中静态变量地址\n");
    printf("0x%08x\n", &n1_max); //打印各本地变量的内存地址
    printf("0x%08x\n", &n2_max);
    printf("0x%08x\n", &n3_max);
    printf("打印 max 函数中 malloc 分配地址\n");
    printf("0x%08x\n", p1_max); //打印各本地变量的内存地址
    printf("0x%08x\n", p2_max);
    printf("0x%08x\n", p3_max);
    printf("打印 max 传入参数地址\n");
    printf("0x%08x\n", &i);
    printf("打印 max 函数中局部变量地址\n");
    printf("0x%08x\n", &m1); //打印各本地变量的内存地址
    printf("0x%08x\n", &m2);
    printf("0x%08x\n", &m3);

    return i == 1 ? 1 : 0;
}

int main(int argc, char **argv)
{
    // static variables
    // .data segment
    static int s1 = 0;
    static int s2;
    static int s3 = 0;

    // dynamic/automatic variables
    // .stack
    int v1 = 0, v2, v3 = 0;

    // heap pointer
    int *p1;
    int *p2;
    int *p3;
    p1 = (int*)malloc(33);
    p2 = (int*)malloc(sizeof(int));
    p3 = (int*)malloc(5);

    printf("打印 max 函数起始地址\n");
    printf("0x%08x\n", max);
    printf("打印程序初始程序 main 地址\n");
    printf("0x%08x\n", main);
    printf("打印各全局变量(已初始化)的内存地址\n");
    printf("0x%08x\n", &g1); //打印各全局变量的内存地址
    printf("0x%08x\n", &g2);
    printf("0x%08x\n", &g3);
    printf("打印各静态变量的内存地址\n");
    printf("0x%08x\n", &s1); //打印各静态变量的内存地址
    printf("0x%08x\n", &s2);
    printf("0x%08x\n", &s3);
    printf("打印各全局变量(未初始化)的内存地址\n");
    printf("0x%08x\n", &bss1); //打印各未初始化全局变量的内存地址
    printf("0x%08x\n", &bss2);
    printf("0x%08x\n", &bss3);
    printf("打印 malloc 分配的堆地址\n");
    printf("0x%08x\n", p1);
    printf("0x%08x\n", p2);
    printf("0x%08x\n", p3);
    printf("打印 argc 地址\n");
    printf("0x%08x\n", &argc);
    printf("打印 argv 地址\n");
    printf("0x%08x\n", &argv);
    printf("打印各局部变量的内存地址\n");
    printf("0x%08x\n", &v1); //打印各本地变量的内存地址
    printf("0x%08x\n", &v2);
    printf("0x%08x\n", &v3);
    printf("======================\n");
    max(v1);
    printf("======================\n");
    return 0;
}