class A
  class << self
    attr_accessor :v1
  end
end

class B
  attr_accessor :v2
end

# 只能使用 Class 来给 B 创建类变量。
# 因为 attr_accessor 给实例用的，B 是 Class 的实例，想要让 B 用，只能在 Class 里面 attr_accessor 了。
# 但这样会让 A 也有 v3
class Class
  attr_accessor :v3
end

A.v1 = 2
print "A.v1: ", A.v1, "\n"

b1 = B.new
b2 = B.new
b1.v2 = 4
b2.v2 = 5
print "b1/b2.v2: ", b1.v2, ", ", b2.v2, "\n"

B.v3 = 3
print "A/B.v3: ", A.v3, ", ", B.v3, "\n"