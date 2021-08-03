def use_blocks(a, b)
  a + yield(a, b)
end

def not_use_blocks(a, b)
  return a + (a+3*b)
end

puts not_use_blocks(1, 2)
puts use_blocks(1, 2) { |x, y| x+3*y }