# struct

## 1. “继承”

或许 golang 不喜欢说那是 “继承”。因为 “伟大的 golang 抛弃了传统落后的 OOP，玩的是面向接口编程，是新时代 C 语言”。

```go
type Student struct {
    Uid  int
    Name string
}

func (s *Student) SayHello() error {
    fmt.Println("Hello")
    return nil
}

type Monitor struct {
    Student
    Level int
}
```

你管这叫 composition 而不叫 inheritance，我是不认可的。

现在 Monitor 可以直接调用 SayHello，而不需要 `monitor.s.SayHello()`。如果一个特性看起来像 “inheritance”（好吧，我承认看起来不像），用起来像 “inheritance”，那它不就是 “inheritance” 吗？
