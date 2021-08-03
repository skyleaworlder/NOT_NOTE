# 对象模型

## 1. 经典面向对象思想

可以通过这样一个简单的类了解 `Ruby` 的面向对象模型设计：

```ruby
class Test_1
    def my_method
        @v = 1
    end
end

obj = Test_1.new
print obj.class
print obj.my_method
print obj.instance_variables
print obj.methods
```

输出如下：

```ruby
=> Test_1
=> 1
=> [:@v]
=> [:my_method, :instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :methods, :singleton_methods, :protected_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :private_methods, :public_methods, :method, :singleton_method, :public_send, :public_method, :define_singleton_method, :extend, :to_enum, :enum_for, :<=>, :===, :=~, :!~, :eql?, :respond_to?, :freeze, :inspect, :object_id, :send, :to_s, :display, :nil?, :hash, :class, :singleton_class, :clone, :dup, :itself, :yield_self, :then, :taint, :tainted?, :untaint, :trust, :frozen?, :untrust, :untrusted?, :equal?, :!, :__id__, :==, :instance_exec, :!=, :instance_eval, :__send__]
```

应该和很多面向对象语言一样吧？方法并非是实例 / 对象的所属物，而是类的固有财产。正如书中所说：**共享同一个类的对象，也共享同样的方法。因此，方法必须存放在类中，而非对象中**。

虽然这里可以通过 `obj.methods` 获取所有的方法，但是这些方法也不是存在于对象中的。方法分为 “对象可调用方法 / 实例方法” 和 “类方法”，那么在这里，`my_method` 属于前者。

我觉得非常需要注意的一点是：**不应该将 “语义” 与 “实现” 等同视之**。看上去是面向对象设计，是符合人类审美的编程思想，但实际上也只是一堆变量的包装，以及一个指向类的引用。

## 2. Ruby 的面向对象本质

在 `Ruby` 中，类也是对象，是一堆实例方法和一个指向其超类的引用（当然，这个类可能没有超类）。

```ruby
obj = Test_1.new
```

因为 `Test_1` 是一个类，按照上面所说，它也是一个对象：

```ruby
print Test_1.class
=> Class
```

那么从其为对象的角度来看，`new` 应该是其对应类 `Class` 的一个实例方法，而事实也是如此：

```ruby
print Test_1.methods.grep(/class/)
=> [:superclass, :class_variables, :remove_class_variable, :class_variable_get, :class_variable_set, :class_variable_defined?, :singleton_class?, :class_eval, :class_exec, :private_class_method, :public_class_method, :class, :singleton_class]
```

可以看到 `class` 和 `superclass` 这些熟悉的方法名。它们看似是 `Test_1` 的类方法，但实际上也是其类 `Class` 的实例方法。

## 3. Ruby 的实体关系

绕口令：

* `Class` 的 `superclass` 是 `Module`；
* `Module` 的 `superclass` 是 `Object`；
* `Object` 的 `superclass` 是 `BasicObject`；
* `BasicObject` 没有 `superclass`；
* 除了上面这些特殊的类，其余只要有 `superclass`，那一定是 `Object`；
* 任何类的 `class` 是 `Class`，`Object` 和 `BasicObject` 的 `class` 也是 `Class`。

### 4. 方法查找

原来 `Ruby` 也有 `receiver` 的概念……我本来打算搜一搜这个名词究竟起源于哪一门语言，但可惜我不是考古学家。

大概的想法是 “确定 `receiver` 到底是哪个类的对象”，然后沿着其类的 `superclass` 一路找上去，直到 `BasicObject`，这个链叫做 “祖先链”。与此同时，`include` 在祖先链内部的 `module` 也要加入祖先链中，且 **在祖先链中的位置** 还要在 **当前 `include` 这个 `module` 的 `class`** 之上。

而 `prepend` 则是将该类放在当前类 **于祖先链上的位置** 之前。

这里需要注意的是，`include` 是紧挨着当前类，但 `prepend` 又不是，所以：

```ruby
class A end
class B end

# ancestors: C -> B -> A
class C
    include A
    include B
end

# ancestors: B -> A -> D
class D
    prepend A
    prepend B
end
```

方法查找要看有没有 `receiver`，有就从 `receiver` 开始往祖先链上面找，或者说，`receiver` 就是 `self`；没有指定 `receiver`，那么就从 `self` 开始（一般是当前祖先链尾）。
