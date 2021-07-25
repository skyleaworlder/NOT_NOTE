# MVVM 和 MVC

由于我自己不清楚，所以只能人云亦云。

虽说是 `MVVM`，但实际上应该是 `V-VM-M`，前端的视图层 `View`，位于前端的视图模型层 `ViewModel`，以及位于后端的 `Model`。

`ViewModel` 提供了对 `View` 的双向绑定，`ViewModel` 中的变量一经更改，就会实时同步到 `View` 层。相当于是提供了一层抽象，使开发者不需要自己手动 `DOM`。

`ViewModel` 同时负责 `View` 和 `Model` 两层的解耦。后端只需要提供接口，前端只需要通过 `ViewModel` 中的变量实现接口调用就可以了。

然后按我个人阅读理解的话……`ViewModel` 这个 `Model` 是对 `View` 层的直接 `Model`，意思就是：这个 `Model` 中的数据 / 变量就是用来方便页面显示的。同时，由于 `ViewModel` 的主体是变量，而非抽象的页面。“变量对变量” 肯定比 “页面对变量” 操作起来方便，所以 `ViewModel` 对实现 `Model` 提供的接口 / 完成与 `Model` 的交互也更加简单。

而 `MVC` 是通过 `Controller` 把 `Model` 和 `View` 分开。用户通过个人操作利用 `Controller`，由 `Controller` 通过 `Model` 读写数据库，此后修改 `View` 并返回用户。
