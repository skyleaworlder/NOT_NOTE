# 有关 MPG 的阅读理解

看了一篇科普文，其中用 “工人、推车和砖头” 形象比喻 `M/P/G`。那篇文章的比喻没有什么生硬的地方，表面上看起来也没有错误的地方，这里只是通过 `runtime` 库做的阅读理解。

无论是 `m struct` 还是 `g struct / p struct`，都不如技术博客里面写得那样简单清晰。这也是可以理解的，作为 `golang` 最基础的调度算法所使用到的结构体，里面就是应该有很多的成员。`golang` 每增加一个特性，都有可能向其中增加适配它的成员。

但这里只记录，不记录具体的语法、特性实现。

```go
type m struct {
    g0      *g          // g0 is for scheduling

    procid  uint64      // each m => a kernel thread
    curg    *g          // g that's binded to this m
    p       uintptr     // p that's binding with m
}

type p struct {
    id      int32
    status  uint32

    m       uintptr
    // mcache is not in struct m
    // using p to process cache
    mcache  *mcache

    runqhead    uint32
    runqtail    uint32
    runnext     uintptr
    runq        [256]uintptr

    gFree       struct { gList, n int32 }
}

type g struct {
    stack   stack
    m       *m

    atomicstatus    uint32  // status of struct g
    goid            int64   // id for goroutine
}
```

`p` 的意思应该是 “虚拟进程”。每个 `p` 在正常情况下都绑定着一个 `m`，同时它肯定绑定着一个 `runq` 队列。如果当前的 `g` 执行完毕，`p` 会从队列中寻找其他 `g` 执行代码。

每个 `m` 对应着一个内核线程，操作系统通过操纵 `m`，来寻找其绑定的 `p` 和 `current g`。

`g` 就是 `goroutine`，有自己的栈、状态和参量。

总的来说，一开始可能有很多的 `p` 未被使用。`m` 被创建出来绑定 `p`。每个 `m` 都有一个 `g` 队列，用于暂存即将上线的 `g`。当 `m` 数量不足时，可能创建新的 `m`；当 `m` 中的 `g` 队列中 `g` 数量太少时，`m` 可能从 `global g queue` 中获取 `g`，或者从其他 `m` 的 `g` 队列中获取 `g`。
