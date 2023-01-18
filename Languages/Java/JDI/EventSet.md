# EventSet

对于一个 Location，可能也会触发多个 Event，所以使用 EventSet 来放置 Events。当使用 `eventQueue.remove` 的时候，就会返回 EventSet。

对于一个 EventSet，也有 suspend 和 resume 的概念，

* SUSPEND_ALL：使用 VirtualMachine.resume；
* SUSPEND_EVENT_THREAD：使用 ThreadReference.resume。因为一个 EventSet 中的 Event 肯定都是来自于一个 Thread。
