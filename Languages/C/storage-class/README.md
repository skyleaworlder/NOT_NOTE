# C 语言存储类型

## 1. static

个人以为可以分成三类：

* 全局静态变量；
* 局部静态变量；
* 静态成员变量。

但是第一类和第三类我觉得差不多？

首先，全局声明的 `static` 变量和方法，只能在 **声明它的文件** 中使用。也就是作用域限定在 **当前文件** 中。`static` 全局变量或方法，可以被文件内的任何函数或方法使用。全局静态变量是被放到程序内存中的 `data` 段中的；函数内声明的 `static` 变量，只能在声明它的函数内使用。

其次，`static` 的初始化只会执行一次。无论是全局变量，还是函数内的局部变量，都只会执行一次。

最后，`static` 变量不能被其他文件的 `extern` 语句定位。

## 2. extern

全局变量的作用域是所有文件。但在 `C` 语言中，变量必须要声明才可以在当前文件中使用。

那么按道理来说，如果在 `static.c` 中定义一个变量，并在 `another.c` 里面定义另外一个同名变量，应该会报 `xxxxx, first defined here` 的错误，表示某个变量被重定义了。

```c
// static.c
int e1 = 1;

// another.c
int e1 = 1;
```

在使用：

```bash
gcc another.c -c
gcc static.c -c
```

之后，会生成 `static.o, another.o`，这是没有问题的，但将它们链接起来的时候：

```bash
gcc another.o static.o -o a.exe
"ld.exe: C:\Users\User\AppData\Local\Temp\ccF7Be77.o:another.c:(.data+0x4): multiple definition of `e1'; C:\Users\User\AppData\Local\Temp\ccMC4ojq.o:static.c:(.data+0x4): first defined here"
```

`extern` 会查找其他文件中是否有该变量的定义，并将该文件中的变量指向那个变量。所以为了让编译器知道某个变量来自于其他文件，应该使用 `extern`。

## 3. auto

`C` 语言中，`auto` 指的是变量作用域 `auto`。如果 `auto` 后不带类型，那么使用 `int` 作为默认类型。`C` 语言中的 `auto` 没什么大用，不会类型推导，在后接类型的时候个人感觉甚至可以直接省略。
