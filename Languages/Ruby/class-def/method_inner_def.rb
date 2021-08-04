class A
  def m1
    def m2; print "m2-self: ", self, "\n"; end
    print "m1-self: ", self, "\n"
  end
end

obja = A.new
pp obja.methods.grep(/^m\w$/)

obja.m1
pp obja.methods.grep(/^m\w$/)

# 虽然 def 开启了一个新的作用域，但是 self 的类型依然是 class A!
# 这其实是符合常理的。
obja.m2

# 现在在 main 之内。
A.class_eval do
  # 输出的是 A，而非 A 的具体实例，因为我用的是 class_eval，而不是 instance_eval!
  print "now-self: ", self, "\n"
  # define a method: m3
  def m3; print "m3-self: ", self, "\n"; end
end

pp obja.methods.grep(/^m\w$/)