# Event

一般用的 class 都在 EventSetImpl.java 里面。Event 是一个 interface，继承于 Mirror（Mirror 的含义是 “用于操纵目标 VM 中的 entity”）。EventSetImpl.java 中的 EventImpl 都直接或间接实现了 Event interface。

Event 一个重要 abstract-class 是 ThreadedEventImpl，该类实现了：

```java
    abstract class ThreadedEventImpl extends EventImpl {
        private ThreadReference thread;

        ThreadedEventImpl(JDWP.Event.Composite.Events.EventsCommon evt,
                          int requestID, ThreadReference thread) {
            super(evt, requestID);
            this.thread = thread;
        }

        public ThreadReference thread() {
            return thread;
        }
    }
```

直接与一个 thread 绑定，这也是获取 Event 基本等价于获取 Thread 的原因。

但仍然有几个类不从 ThreadedEventImpl 开始继承：

| 类名 | 继承父类 |
|:-:|:-:|
| ClassUnloadEventImpl | EventImpl |
| VMDeathEventImpl | EventImpl |
| VMDisconnectEventImpl | EventImpl |

**剩下的 class 都从 ThreadedEventImpl 开始继承**，尤其是 LocatableEventImpl，EventSetImpl.java 中有不少都是继承于这个类（和代码有关）。

LocatableEventImpl 有一个 location property，详见 [Location](Location.md)，extends 实现了该 interface 的 class 有能力表示位置：

* Breakpoint；
* Step；
* MethodEntry / MethodExit；
* Exception；
* ……

总之就是平常使用 IDE 本地调试时经常使用的功能都可以和 Location 有关。
