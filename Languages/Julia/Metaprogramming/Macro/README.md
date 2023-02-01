# Macro

需要注意的点：

* macroexpand
* macro 的生成
* esc 的使用

## 0. macroexpand

没理解前多用 `macroexpand`。

## 1. macro 的生成

就是替换。但是相较于 C / C++ 的 macro，julia 的 macro 看起来不容易直接理解，我的评价是在语言设计的时候或许因为过分注重可读性和一致性导致缺乏可读性。

```jldoctest
julia> macro wrapper(func_call)
           return quote
               println("Hello!")
               $func_call
           end
       end
@wrapper (macro with 1 method)

julia> add(a, b) = a+b
add (generic function with 1 method)

julia> @wrapper add(1,2)
Hello!
3
```

macroexpand 之后，可以看出是替换：

```jldoctest
julia> @macroexpand @wrapper add(1,2)
quote
    #= REPL[17]:3 =#
    Main.println("Hello!")
    #= REPL[17]:4 =#
    Main.add(1, 2)
end
```

macro 的定义与函数类似，上面展示的是 macro 与 function 不同的地方。

```jl
macro wrapper(func_call)
    println("Hello!")
    return quote
        $func_call
    end
end
```

从执行结果来看都是：

```jldoctest
julia> @wrapper add(1,2)
Hello!
3
```

但宏展开结果不同，非常明显的，上述 wrapper 展开后是：

```jldoctest
julia> @macroexpand @wrapper add(1,2)
Hello!
quote
    #= REPL[21]:4 =#
    Main.add(1, 2)
end
```

在 macro wrapper 作用时，println 就已经执行。也就是说，macro 分为 "parse time" 与 "runtime"。（See also https://docs.julialang.org/en/v1/manual/metaprogramming/#Hold-up:-why-macros?）

正如编译期和运行时，很多事情只能在运行时做。在 macro 这边就类似于替换。

## 2. esc 的使用

esc 全程 escaping，指的是其所容纳的 Expr 超出当前 macro "作用域"，访问外部的 variable。比如：

```jldoctest
julia> x, y = 2, 1
(2, 1)

julia> @macroexpand @cond_if (x > 1) begin
           y = 3
           println(y)
       end
quote
    #= REPL[24]:3 =#
    if Main.x > 1
        #= REPL[24]:4 =#
        begin
            #= REPL[27]:2 =#
            var"#1#y" = 3
            #= REPL[27]:3 =#
            Main.println(var"#1#y")
        end
    end
end
```

然而：

```jldoctest
julia> @macroexpand @cond_if (x > 1) begin
           y = 3
           println(y)
       end
quote
    #= REPL[29]:3 =#
    if Main.x > 1
        #= REPL[29]:4 =#
        begin
            #= REPL[32]:2 =#
            y = 3
            #= REPL[32]:3 =#
            println(y)
        end
    end
end
```

可以看出前者声明了新的变量，而后者直接修改外部变量。

所以也可以知道：

* 如果没有加 esc，但是直接使用外部变量，运行报错（没有捕获）；
* 加了 esc 确实会对外部变量造成影响，这与闭包不同（并非捕获）。
