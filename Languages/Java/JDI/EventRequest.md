# EventRequest

## 1. 继承关系

这也是一个 interface。最有代表性的实现类应该是 BreakpointRequestImpl 和 ExceptionRequestImpl。

EventRequestImpl 是实现这个接口的抽象类，该类有一系列 abstract sub-class：

|类名|父类|作用|
|:-:|:-:|:-:|
|ThreadVisibleEventRequestImpl|EventRequestImpl||
|ThreadStartRequestImpl|ThreadVisibleEventRequestImpl||
|ThreadDeathRequestImpl|ThreadVisibleEventRequestImpl||
|ClassVisibleEventRequestImpl|ThreadVisibleEventRequestImpl||
|BreakpointRequestImpl|ClassVisibleEventRequestImpl||
|ClassPrepareRequestImpl|ClassVisibleEventRequestImpl||
|ClassUnloadRequestImpl|ClassVisibleEventRequestImpl||
|ExceptionRequestImpl|ClassVisibleEventRequestImpl||
|MethodEntryRequestImpl|ClassVisibleEventRequestImpl||
|MethodExitRequestImpl|ClassVisibleEventRequestImpl||
|MonitorContendedEnterRequestImpl|ClassVisibleEventRequestImpl||
|MonitorContendedEnteredRequestImpl|ClassVisibleEventRequestImpl||
|MonitorWaitRequestImpl|ClassVisibleEventRequestImpl||
|MonitorWaitedRequestImpl|ClassVisibleEventRequestImpl||
|StepRequestImpl|ClassVisibleEventRequestImpl||
|WatchpointRequestImpl|ClassVisibleEventRequestImpl||
|AccessWatchpointRequestImpl|WatchpointRequestImpl||
|ModificationWatchpointRequestImpl|WatchpointRequestImpl||
|VMDeathRequestImpl|EventRequestImpl||

（在对一个 EventRequestManager 操作的时候，由于其绑定了 vm，所以传入的 ThreadReference / ReferenceType 等实现了 Mirror interface 的类都应该与 EventRequestManager 具备相同的 vm）

## 2. 不可修改列表

每个 EventRequest 都有一个 setEnable 方法，只有 EventRequest 被 enable 之后才会生效。**EventRequest 有很多种类，相同种类的 EventRequest 会被放在一个 “不会被修改” 的 List 中。如果 EventRequest 没有被 enable，它也会被一直放在 unmodifiableRequestList 中，但这些 EventRequest 并不奏效**。

## 3. suspend policy

suspend policy 和 EventRequest 是联系非常紧密的两个概念。其指的是：**当 EventRequest 发生时，停止线程的 policy**。

* SUSPEND_ALL：停止 VM 中的所有线程，也就是 ThreadReference.suspend；
* SUSPEND_EVENT_THREAD：停止触发事件的那个线程，也就是 VirtualMachine.suspend。

**suspend 和 resume 是一对概念**。由于经常使用 EventSet.resume，所以可以看向 EventSet 部分。
