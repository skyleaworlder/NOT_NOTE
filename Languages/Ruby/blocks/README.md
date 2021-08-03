# 代码块

## 1. 固有作用域

有意思的是，`Ruby` 没有嵌套式作用域。外部作用域中的变量对内部作用域不可见。就比如这个目录下的 `gate.rb` 所写的一样：

```ruby
v1 = 1
$v2 = 2
@v3 = 3
print "local_variables:", local_variables, "\n"
print "instance_variables:", instance_variables, "\n"

module M1
  v4 = 4
  $v5 = 5
  @v6 = 6
  print "M1 scope: local_variables:", local_variables, "instance_variables:", instance_variables, "\n"
end
```

输出的结果为：

```bash
local_variables:[:v1]
instance_variables:[:@v3]
M1 scope: local_variables:[:v4]instance_variables:[:@v6]
```

`class` 以及 `def` 同理。正如书上所说，`Ruby` 中的 `module / class / def` 会开启一个新的作用域。而看到这三者对应的 `end` 时，作用域又会切换为之前的作用域。

### i. 顶级作用域

在 “最外层” 也可以定义实例变量 `@v3`，这是因为 “最外层” 也处在一个类中。`main` 被称作顶级作用域：

```ruby
puts self       # => main
puts self.class # => Object
```

可以通过 `self` 查看当前作用域，这不仅仅适用于顶级作用域，其他的也可以。

### ii. 作用域内语句执行

`module / class` 中的语句会立刻执行，但是定义在方法中的不会。

## 2. 作用域处理方法

`module / class / def` 这三个关键字会开启新的作用域，但是创建一个 `module / class / method` 从来都不是只有一个方法，可以使用 `Module.new / Class.new, define_method` 躲避新作用域的开启，可见 `flatting_scope`：

```ruby
B = Module.new do
  v2 = 3

  C = Class.new do
    define_method :get_v do
      return v2
    end

    define_method :get_name do
      return "Class: C"
    end
  end
end

objc = C.new
print objc.get_v, "\n"
print objc.get_name, "\n"
```

主要是因为：

* `Module.new / Class.new / define_method` 可以躲避新作用域的开启；
* 利用闭包，代码块可以捕捉外部作用域的变量。

## 3. 闭包直觉上的例外

虽然闭包会将其 **周围环境中的变量** 捕捉，但是什么才叫 **“周围”**，如何定义这个 **“周围”**，究竟哪些变量对其是可见的？

正常来说的话，这个代码块所在的块中。但这只是大多数情况。真要计较的话，应该要看这个代码块的 `self` 是什么。

```ruby
class C
  def initialize
    @v1, @v2 = 1, 2
  end
end

class D
  def d1
    @v1, @v2 = 3, 4
    puts "@v1 = #{@v1}, @v2 = #{@v2}"
    # 需要注意，这里的 instance_eval 的 receiver 是 C.new 出来的一个对象。
    # 所以这里的 `self` 变成了 class C，而非 class D。
    # 于是 v1 和 v2 的值也变了。
    C.new.instance_eval do
      # 这里输出的 self 可不是 D，而是 C
      puts self
      puts "@v1 = #{@v1}, @v2 = #{@v2}"
    end
  end
end
```

之前在 `Class.new` 里面 `define_method`，如果要 `puts self`，那获得的输出肯定是 `C`。（哪怕仍在 `Class.new` 中，哪怕 `C` 看起来还没有创建好）
