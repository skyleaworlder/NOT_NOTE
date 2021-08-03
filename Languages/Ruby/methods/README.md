# 方法

## 1. 动态调用方法

在 `Ruby` 中调用方法不一定需要在对象后面打一个 `.`，后接方法的名字，还可以像这样：

```ruby
class A
  def println(input)
    puts input
  end
end

obja = A.new
obja.send(:println, 3)
```

如果在 `.` 后接方法的话，那么调用什么方法是写死了的。

但由于 `Symbol` 和 `String` 在 `Ruby` 中可以互相转化，并且 `Ruby` 不是一个编译型语言。使用 `send` 的话，调用什么方法是在运行时才能决定的：

```ruby
def a; puts "call a"; end
def b; puts "call b"; end
def c; puts "call c"; end

def think(input)
  send input.to_sym
end

think("a")
```

## 2. 动态定义方法

使用 `define_method` 可以在任何时间、任何地点定义当前 `self` 下的一个方法：

```ruby
define_method :wtf do | x |
  puts x+1
end
```

它的优势与上面的 `send` 相似，都是可以在运行时定义方法。我个人感觉这个是比较恐怖的，我可以让我的程序运行到某个时刻，就多出一个可用的方法。

这里可以插一句，使用 `Ruby` 原生的 `undef` 可以取消方法的定义，但是 `undef` 会在试图取消一个不存在的方法定义时报错。

## 3. 幽灵方法

我也觉得不好，就用 `define_method` 算了。

## 4. Method 对象

这一节本来是后面一章的内容，但毕竟也是在讲 `Method` 的调用。

一般来说要这样调用方法：

```ruby
class A
  def get_v1
    return 1
  end
end

obja = A.new
print obja.get_v1
```

但还可以像这样：

```ruby
class A
  def get_v1
    return 1
  end
end

obja = A.new
# 创建一个 Method 类，用于接收方法
v1 = obja.method :get_v1
print v1.call
```

这里的 `v1` 是一个 `Method` 类，通过 `Method` 的 `call` 方法后接 “符号” 可以调用原本的方法。但由于符号可以和字符串互相转化，所以这就可以玩很多花样（

需要注意的是，在 `Ruby` 中不能这样：

```ruby
class A
  def a
    return 1
  end

  def b(b1, b2)
    print b1, b2
  end

end

obja = A.new
print obja.a.class # => Integer
print obja.b.class # error!
```

反正就是不行，它想先执行 `a` 方法，然后再求返回值的类型，而 `obja.b` 是无法调用成功的，所以会报错。
