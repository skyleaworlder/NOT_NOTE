# A is a class without constructor.
class A
  @v1, @v2 = 1, 2
  @@v3 = 3

  def write; @v2 = 3; end
  def read; return @v2, @@v3; end
  def self.write; @v2 = 30; end
  def self.read; return @v2, @@v3; end
end

# B has a constructor.
class B
  @v1, @v2 = 1, 2
  @@v3 = 3
  def initialize
    @v1, @v2 = 10, 20
  end

  def write; @v2 = 3; end
  def read; return @v2, @@v3; end
  def self.write; @v2 = 30; end
  def self.read; return @v2, @@v3; end
end

a1 = A.new
a2 = A.new
#=============
print "a1.read before assign:", a1.read, "\n"
a1.write
print "a1.read after write:", a1.read, "\n\n"

print "a2.read before assign:", a2.read, "\n"
a2.write
print "a2.read after write:", a2.read, "\n\n"

print "A.read before assign:", A.read, "\n"
A.write
print "A.read after write:", A.read, "\n\n"
#=============

b1 = B.new
b2 = B.new
#=============
print "b1.read before assign:", b1.read, "\n"
b1.write
print "b1.read after write:", b1.read, "\n\n"

print "b2.read before assign:", b2.read, "\n"
b2.write
print "b2.read after write:", b2.read, "\n\n"

print "B.read before assign:", B.read, "\n"
B.write
print "B.read after write:", B.read, "\n"
#=============
