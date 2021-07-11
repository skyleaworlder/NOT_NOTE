# 中断

现在所说的 “中断” 有两种含义：

* 处理外部设备事件（外中断）；
* 外中断 + 内中断（异常）。

如果是 “狭义中断”，那么仅仅需要考虑 **外设与操作者** 的行为。

如果是 “广义中断”，那么 **异常、系统调用** 都应该归为中断。（**系统调用归为广义异常中**）。

**自愿中断** 是异常的一种，也是内中断的一种，也叫做 **陷入**。系统调用应该就属于 **自愿中断**。通过具备 `trap` 功能的指令，从用户态进入内核态。

**程序出错** 是异常的一种，也就是内中断的一种。包括硬件故障和软件错误。硬件故障多少可以通过 “错误处理程序” 恢复，而软件错误，也就是程序中的逻辑错误，则是必须终止程序才可以。

## 一、描述一次系统调用过程

### 1. 将 “中断” 作为准备工作

我觉得在最开始需要提一嘴，为了完成一次系统调用，操作系统需要具备基本的中断处理功能。

首先是 **中断处理程序(Interrupt Handler)**。如果具体到每个中断过程，肯定有一部分是存在共性的，但肯定还有一部分各不相同。这不相同的部分就是针对于该特定中断的 **中断处理程序**。

写好 **中断处理程序** 之后，还需要调用它。在 `Unix V6++` 中，调用这个处理程序是极为简单的：

```c
#define CallHandler(Class, Handler) \
    __asm__ __voltaile__(" call *%%eax" :: "a" (Class::Handler));
```

其次是 **中断入口程序(Interrupt Entrance)**。上面说了，中断过程有一些共性。比如保存现场、恢复现场；比如进入内核态、优先级处理。用一个函数来封装真正的 **中断处理程序**，交付给系统直接调用。这里以系统调用入口程序为例：

```c
void SystemCall::SystemCallEntrance() {
    SaveContext();
    SwitchToKernel();
    CallHandler(SystemCall, Trap);

    struct pt_context* context;
    __asm__ __volatile__(" movl %%ebp, %0; addl $0x4, %0 " : "+m" (context));

    if (context->xcs & USER_MODE) {
        while (true) {
            X86Assembly::CLI();
            if (Kernel::Instance().GetProcessManager().RunRun > 0) {
                X86Assembly::STI();
                Kernel::Instance().GetProcessManager().Swtch();
            }
            else {
                break;
            }
        }
    }

    RestoreContext();
    Leave();
    InterruptReturn();
}
```

其次是 **中断描述符表(IDT)**。入口程序需要在 `IDT` 中注册。上面的 `SystemCall::SystemCallEntrance` 也在其中，当 `INT 0x80` 的时候，就会调用 `SystemCall::SystemCallEntrance`：

```c
void Machine::InitIDT() {
    this->m_IDT = &g_IDT;

    // set default handler
    for ( int i = 0; i <= 255; i++ ) {
        if( i < 32 )
            this->GetIDT().SetTrapGate(
                i, (unsigned long)IDT::DefaultExceptionHandler);
        else
            this->GetIDT().SetInterruptGate(
                i, (unsigned long)IDT::DefaultInterruptHandler);
    }

    /* 此处省略一部分中断的注册 */

    this->GetIDT().SetInterruptGate(
        0x20, (unsigned long)Time::TimeInterruptEntrance);
    this->GetIDT().SetInterruptGate(
        0x21, (unsigned long)KeyboardInterrupt::KeyboardInterruptEntrance);
    this->GetIDT().SetInterruptGate(
        0x2E, (unsigned long)DiskInterrupt::DiskInterruptEntrance);
    this->GetIDT().SetTrapGate(
        0x80, (unsigned long)SystemCall::SystemCallEntrance);
}
```

最后，`Unix V6++` 在内核刚刚启动时使用 `Machine::InitIDT` 注册所有中断：

```c
extern "C" int main0(void) {

    Machine& machine = Machine::Instance();

    /* 此处省略一部分代码 */

    machine.InitIDT();
}
```

也就是说，在内核启动后，系统通过 `InitIDT` 注册了一系列中断描述符，这其中就包括 **系统调用入口程序**。该入口程序在执行 `INT 0x80` 后会被调用。那么该如何调用呢？

### 2. open 系统调用的过程

这肯定需要内联汇编。以库函数 `open` 为例：

```c
int open(char* pathname, unsigned int mode) {
    int res;
    __asm__ __volatile__ (
        "int $0x80" : "=a"(res) : "a"(5), "b"(pathname), "c"(mode)
    );
    if (res >= 0)
        return res;
    return -1;
}
```

这句汇编的意思就是：**执行 “INT 0x80”，EAX, EBX, ECX 分别为 5, pathname, mode；结束后，本放在 EAX 的值给 res 变量**。

执行 `INT 0x80` 之后，系统就应该执行中断处理程序，毕竟执行了 `INT` 指令。`0x80` 号中断在 `IDT` 中早有记录，恰好是系统调用，于是就应该执行 `SystemCall::SystemCallEntrance` 函数，其中有一句：

```c
void SystemCall::SystemCallEntrance() {
    /* 省略部分代码 */

    CallHandler(SystemCall, Trap);

    /* 省略部分代码 */
}
```

这个 `CallHandler(SystemCall, Trap)` 就是 `Call SystemCall::Trap`。`CallHandler` 在系统调用这里，实际上就是 **调用 SystemCall::Trap** 函数。

在这个陷入函数中，有这么一段：

```c
void SystemCall::Trap() {
    /* 省略部分代码 */

    SystemCallTableEntry *callp = &m_SystemEntranceTable[regs->eax];
    Trap1(callp->call);

    /* 省略部分代码 */
}
```

这里实际上就是将 **系统调用处理子程序** 传入了 `Trap1` 中执行。在 `open` 中，往寄存器 `EAX` 中传入了一个 5，而这个 5 的意思是：它是 `SystemCall::m_SystemEntranceTable` 中的第 5 个系统调用入口程序：

```c
SystemCallTableEntry SystemCall::m_SystemEntranceTable[SYSTEM_CALL_NUM] = {
    { 2, &Sys_Open  },              /* 5 = open */
}
```

而 `Sys_Open` 是系统调用。

用户态成功过渡到核心态，开始执行 `Sys_Open` 函数。
