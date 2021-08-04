# 类定义

## 1. self

`self` 表示了当前对象。像之前所说的，`module / class / def` 回开启新的作用域，然而 `Ruby` 提供了顶级作用域，我有理由怀疑这个顶级作用域也是一个 `module / class / method`：

```ruby
puts self, self.class

# self => main
# self.class => Object
```

正说明程序顶层的类是 `Object`，是 `main` 对象所属的类。（如果定义一个类，其属于 `Class` 类，而其 `superclass` 为 `Object` 类）

**注：由于 `main` 的类是 `Object`，所以其祖先链为：`[Object, Kernel, BasicObject]`，但一般自定义类的类为 `Class`，其祖先链为：`[Class, Module, Object, Kernel, BasicObject]`。所以在顶级作用域下，有些定义在 `Module` 中的方法是无法使用的！比如 `alias_method`**。

而对于 `module / class` 而言，在开启作用域的同时，也更换了 `self`。但 `def` 不会改变 `self`，因为定义的是方法，方法当然从属 `module / class`，下面这个例子可以很好地说明 `def` 与 `class / module` 在此时的区别：

```ruby
class A
  def m1
    def m2; print "m2-self: ", self, "\n" end
    print "m1-self: ", self, "\n"
  end
end

obja = A.new
pp obja.methods.grep(/^m\w$/)

obja.m1
# m1 会输出 A 类
pp obja.methods.grep(/^m\w$/)

obja.m2
# m2 同样会输出 A 类，并且和上面 m1 的输出一样，指向同一个对象。
```

之前说了，可以通过 `define_method` 在当前 `self` 之下定义一个方法，看起来已经很灵活了，但这样依旧不能满足大部分时候的要求。更多的时候，我甚至不在那个 `self` 中。（变换 `self` 和开启作用域一样麻烦）

还是希望可以不更换 `self`，或者临时创建一个 `self`，让我定义 `self` 下的方法：

```ruby
# 接上文，现在已经是 main 对象内的顶级作用域下了。
A.class_eval do
  # 输出的是 class A，而非 class Object
  print "now-self: ", self, "\n"
  # define a method: m3
  def m3; print "m3-self: ", self, "\n" end
end

pp obja.methods.grep(/^m\w$/)
```

那这里就很明显了——既然 `A.class_eval` 中的 `print "now-self: ", self` 的输出是 `A`，而非 `main`，下面对 `m3` 的定义也就是在 `A` 中。

所以 `obja.methods` 中我还是定义出了第三个方法。

* 定义 `class / module` 时，我使用 `Class.new / Module.new` 避免开启新作用域；
* 定义 `class / module` 中的 `method` 时：
  * 我可以直接在 `self` 下使用 `define_method` 定义当前 `self` 的方法，以避免开启新作用域；
  * 也可以通过 `<Class>.class_eval / <Module>.module.eval` 切换到目标 `self` 下后，再 `def / define_method` 定义方法。

在前面讲 `block` 的一章中，提到了 `instance_eval` 方法，其与 `class_eval / module_eval` 之间可以如此取舍：

* 如果我想要使用一个实例中的实例变量，那肯定是 `instance_eval`；
* 如果我只想定义一些方法，改变一些类的类变量，应该用后者吧。

## 2. 实例变量 / 实例方法 / 类实例变量 / 类方法 / 类变量 / 类属性

这语言太怪了……但也不是不能理解。

因为 `Ruby` 中定义出来的 `class` 全部都是以 `Class` 为类的实例，既然是实例，那应该是有变量的，也应该有方法的。于是：

```ruby
class A
  # 类变量，无论是实例方法还是类方法都可以看到。
  @@v1 = 1
  # 类实例变量，这个变量只有类方法才能直接看到。
  @v2 = 2

  def initialize
    # 实例变量
    @v3 = 3
  end

  # 实例方法
  # 因为 initialize 已经执行过了，所以可以看到 initialize 中已经初始化的变量。
  # 但是看不到 “类实例变量” @v2，因为和 A 不是同一个对象。
  def m1; @v3; end

  # 类方法（可以看到类实例变量）
  # 这个方法定义在了 self 中，self 就是 A，所以是实例 A 的方法，而不是 A 类的实例的方法。
  # 或者说是类方法，如果引入后面的 “单件” 概念，那么类方法就是 “一个类的单件方法”。
  def self.m1; @v2; end
end
```

还不能说这是静态变量，因为静态变量是类共用的。正如书上所说：**类实例变量 只可以被类本身访问，但不能被类的实例或者子类所访问**，所以类变量更像静态变量。但要说的话，`Ruby` 的类变量也还不是静态变量，麻了……

最后说类属性，我感觉 “类属性” 的英文应该是 `class properties`，是只属于一个类的公用的变量。可以通过在 `Class` 中 `attr_accessor` 做到这一点，但并不好，具体可见 `class_properties.rb`：

```ruby
# 这是好的。
class C
  class << self
    attr_accessor :v3
  end
end
```

类属性是属于一个类的，相当于是类的 `metadata`，比如我可以这么定义：

```ruby
class Book
  def initialize(name, price)
    # 表示一本书的书名和价格。
    @name = name
    @price = price
  end

  class << self
    # 表示这个类的作者、版本号和最后更新时间。
    attr_accessor :author, :version, :update_time
  end
end
```

大概用法是这样，但在我看来它依旧不是静态变量。

## 3. 单件类(singleton class)

顾名思义，单件类肯定只有一个实例。以下是创造单件类的方法：

```ruby
class A
  def m1; end
end

singleton = class << A
  def m2; end
end
```

尽管如此，`singleton.class` 的结果还是 `A`。可是这里的 `singleton` 就是一个单件类的实例，并且也的确定义了一个新的方法 `m2`，我可以通过 `singleton.m2` 调用，但 `A` 明显不具备 `m2` 方法，这可以通过 `A.methods.grep(/m2/)` 以及 `A.private_methods.grep(/m2/)` 的结果确认。所以 `singleton` 的 `class` 的确不应该是 `A`。

可以使用 `singleton.singleton_class` 查看这个实例所属的类，得到的结果是：`#<Class:A>`，而不是 `A`。这是符合常理的。通过 `class << A` “继承” / “包装” 了原有的 `A`，增加了（也可以覆写）方法。

之前有这么一个说法：“每一个定义好的类，都是一个对象。每一个类都是 `Class` 这个类的实例”。这确实，但从实例的角度再出发，因为 `singleton.singlton_class` 返回的是 `#<Class:A>`，所以对于 `A` 这个实例，有理由怀疑它的单件类究竟是什么类型：

```ruby
A.singleton_class               # => #<Class:A>
A.singleton_class.class         # => Class
A.singleton_class.superclass    # => #<Class:Object>
A.singleton_class.superclass.superclass.superclass # => Class
```

正如同一般类 / 实例的祖先链，单件类也有自己的一套祖先链，并且这套链能过和前者很好地结合在一起。

## 4. 类方法的定义

```ruby
class A
  def m1; end
  def m2; end
end
def A.singleton_m1; end
def A.singleton_m2; end

class B
  def m1; end
  def m2; end
  def self.singleton_m1; end
  def self.singleton_m2; end
end

class C
  def m1; end
  def m2; end
  class << self
    def singleton_m1; end
    def singleton_m2; end
  end
end
```

很明显，这第三种最好看了，用 `class << self end` 完美表现了单件方法的定义，并把类方法和实例方法区分开来。

## 5. 方法包装器

前面的单件类对这个话题没有特别大的必要性。

书上给出了 `alias_method / alias, refine, prepend` 三种方式。但我觉得没必要搞这些啊，所以我没怎么看。
