# Location

Location 是一个重要的 interface，LocationImpl 可以表示 VM 的一个点。

JDI 中使用 Location 来标识 breakpoint 的位置。

Location 还可以返回当前所处的 Type（Type 是 DeclaringType，private 应该也可以）以及 Method。
