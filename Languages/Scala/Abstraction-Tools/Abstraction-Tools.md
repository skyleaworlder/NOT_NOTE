# 用于抽象的工具

本来想叫 `OOP-Tool` 的，因为 `Tool` 是 `Scala 3` 官方文档的小标题。但转念一想它的对象模型又不仅仅是为了 `OOP` 服务的，所以还是叫的更抽象一些吧。

## 1. Classes

类是 `Scala` 关键的抽象工具。如果仅仅谈 `class` 的话，它能够扮演的职责甚至不如 `Python` 的 `class`。

### i. 成员可见性

从成员可见性角度出发，`Scala` 给出了更见简明的定义方法。举几个简单例子，在 `C++` 和 `TypeScript` 中：

```cpp
class A {
private:
    int __a;
public:
    int b;
    A(int a, char b) : __a(a), b(b) {}
};
```

```typescript
class A {
    private __a: number;
    constructor(__a: number, __b: string) {
        this.__a = a
        this.__b = b
    }
}
```

`Scala` 为定义这样的类提供了简单的语法：

```scala
class A(a: Integer, var b: String)
```

首先，`Scala` 的入参自然就会绑定为类中的成员。其次，如果是一个不使用任何 `access modifier` 修饰，那么它就是一个 `private property`。

### ii. 成员可变性

与一般变量相同，同样可以用 `val` / `var` 来修饰类成员：

```scala
class B(val imut: Integer, var mut: Double):
    // 这个会报错
    // def changeImut(new_val: Integer) = imut = new_val
    def changeMut(new_val: Double) = mut = new_val
```

### iii. 类定义就是构造函数

哈哈啊哈哈哈哈我管它叫：`CDIC`

> Class-Definition-Is-Constructor

`Scala` 的类体中可以定义方法，可以执行语句。所以看起来，`Scala` 和其他语言非常不一样：

```python
class C:
    def __init__(self, a, b):
        self.a = a
        self.b = b

    def other_method(self, c):
        print(f"{a} + {b} = {c}!!!")
```

```ruby
class C
  @v1, @v2 = 1, 2
  @@v3 = 3
  def initialize
    @v1, @v2 = 10, 20
  end

  def write; @v2 = 3; end
  def read; return @v2, @@v3; end
```

在别的语言中，定义一个类，也就是类下的 `Block`，要么是定义一些 `properties`，要么是一些 `method` 的定义或复写。但是 `Scala` 可以这样：

```scala
class C(val a: Integer, val b: Integer):
    println("constructor begin")
    val c = a + b
    println(s"property c is $c")

    def printCCC = println(s"ccc: $c $c $c")
    printCCC
    println("constructor end")
```

怎么说，就之前我是没见过。

### iv. 备用构造函数

按我的理解就是构造函数的重载，一个类可以有多种构造方式。

在 `Java` 和 `C++` 中这样的重载非常常见。在 `Scala` 中，由于整个类的定义已经算得上是一个构造函数了，那么 `Scala` 就整了个很怪的方法来定义额外的构造函数：

```scala
// 这是一个无参构造函数
class D(var haha: Integer):
    private var _hehe = "wqe"
    private var hihi = "qwe"

    def this(haha: Integer, hehe: String) = {
        this(haha)
        _hehe = hehe
    }
```

在 `this` 中可以通过 `this` 调用其他构造函数。

## 2. Objects

### i. object 定义了类

大概是我见识短浅，我第一次看到语言有这样的语言特性。`object` 可以创造一个名为 `object` 后面跟的那个 `indentifier` 同名的单体类 (`Singleton`)。

`object` 也是一个类。（哈哈哈让我想起了 `ruby` 中 `Class` 也是一个 `Object`）所以可以这样使用：

```scala
object A:
    private val oa = 1
    def printOA = println(oa)

A.printOA
```

所以可以把很多与类无关的事物，拆分到 `object` 中。在 `Python` 中，经常使用 `@classmethod` 与 `@staticmethod`：

```python
class A:
    CLASS_NAME = "A"

    def __init__(self, a):
        self.a = a

    @classmethod
    def PrintClassName(cls):
        print(cls.CLASS_NAME)

    @staticmethod
    def DoSomethinigElse():
        print("Hahaha", "This method is independent")
```

### ii. 用于抽象工具类

写 `Python` 的时候经常写一个全是 `@classmethod` 的工具集合。不得不说，那是人想出来的 `Python` 可以那么写。但在 `Scala` 中是专门设计了这么一个特性来放那些零部件。

这里简单复制一下官方文档的例子：

```scala
// StringUtils.scala
object StringUtils:
  def truncate(s: String, length: Int): String = s.take(length)
  def containsWhitespace(s: String): Boolean = s.matches(".*\\s.*")
  def isNullOrEmpty(s: String): Boolean = s == null || s.trim.isEmpty

// And in another package
import StringUtils.{truncate, containsWhitespace}
truncate("Charles Carmichael", 7)       // "Charles"
containsWhitespace("Captain Awesome")   // true
```

### iii. Make Class Great Again

这个思想大概是：“`class` 里面就应该好好定义只和实例化过后的 `instance` 有关的东西。什么和类有关但是和实例无关的东西，一并放入一个单体类就好了。不仅仅编译后只生成一遍，定义的时候也不写在一起吧。” 这大概就是类似 `C++ namespace` 的效果。

### iv. object 工厂

在 `object` 中定义 `apply` 方法，相当于是给同名 `class` 定义构造函数。

```scala
class E:
    var e1: Int = -1
    var e2: String = ""

object E:
    def apply(e1: Int): E = {
        var inst = new E
        inst.e1 = e1
        inst
    }

var obj_e1 = E(12)
```

这是一个语法糖，可以不使用 `new` 直接创建一个实例。（不用 `new` 的话会用 `object` 中定义的 `apply` 方法）

这是一个非常关键的点。可能需要注意判断某些内建类在 `new(class 下构造函数) / apply(object 下工厂方法)` 的差别。

## 3. Traits

### i. 面向接口编程

作为新时代 `OOP` 语言，`Scala` 算是明面上抛弃了 “类继承” 那一套，而是使用 “接口”。

相较于 `rust` 中的同名关键字，`Scala` 的 `trait` 能轻松定义更多东西，就和一个抽象类差不多：

```rust
pub trait F {
    fn F1(&self) -> String;
}
```

```scala
trait F:
    def F1(): String
    def F2() = println("default implementation")

    def not_only_method: Double
    def but_some_property: Int
```

### ii. 像继承一样实现

为什么这么说，因为 `Scala` 用的是 `extends`（bushi

话说 `Scala` 貌似不允许定义一个在初始化阶段没有被赋予初值的成员。也就是说，类似 `JavaBeans` 的实现是禁止的：

```java
class Jvb {
    private String jvb_str;
    public Jvb() {}
    public String getJvbStr() { return this.jvb_str; }
    public void setJvbStr(String jvb_str) { this.jvb_str = jvb_str; }
}
```

在 `Scala` 中只能通过 `trait` 或者 `abstract class` 定义。毕竟 `Scala` 的 `trait` 不仅仅是声明一个方法的集合，定义一系列接口而已，它还支持参数。

```scala
trait F(f1: String):
    def F1(): String
    def F2() = println("default implementation")

    def not_only_method: Double
    def but_some_property: Int
    def support_params: Int = f1.length
```

### iii. 接口继承

`rust` 中可以通过：

```rust
pub trait G: F {}
```

实现 `trait` 之间的继承。

`Scala` 中也可以通过：

```scala
trait G extends F {}
```

完成继承。我觉得这样可读性是要比 `go` 那种高很多呀。

## 4. Enums

### i. 枚举是枚举

像 `C++` 一样，一般的 `enum` 都是有其对应值的，看起来就好像是在赋予一些 `Magic Number` 以可读性：

```cpp
enum H {
    H1 = 2,
    H2 = 4,
    H3 = 6
};
```

但是 `Scala` 的枚举就是枚举：

```scala
enum H:
    case H1, H2, H3
```

不存在说它们对应 `Int` 类型的某些值。我想这是为了方便模式匹配：

```scala
val h = H.H1
h match
    case H.H1 => println("h1")
    case H.H2 => println("h2")
    case _ => {}
```

### ii. 枚举带值

我感觉这更是一种魔法，身为枚举 `case` 的自身继承枚举本身：

```scala
enum I(val i: Double):
    case I1 extends I(1.2)
    case I2 extends I(1.2)
    case I3 extends I(3.6)
```

这样就可以在定义不同的枚举 `case` 时，令它们同时还具备相同属性了。

## 5. Case classes / Case objects

### i. 面向 FP 特性

在普通 `class` 中，默认是 `private immutable`，但在 `case class` 中是 `public immutable`。

### ii. 快速创建

有的时候可能需要根据不同 `case` 创建，但它们本身都具备相同特性。这可能就是面向接口，而 `case class` 让这个想法更可读：

```scala
trait J
case class J1(i: Int) extends J
case class J2(s: String) extends J
case class J3(d: Double) extends J

val j = J1(12)
j match
    case J1(i) => println(i)
    case J2(s) => println(s)
    case J3(d) => println(d)
    case _ => println("...")
```

由于 `case class / object` 中实现了 `unapply` 方法，所以在 `match` 的时候可以解出用于初始化的参量。