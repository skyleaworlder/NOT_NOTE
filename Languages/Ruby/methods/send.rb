def a; puts "call a"; end
def b; puts "call b"; end
def c; puts "call c"; end

def think(input)
  send input.to_sym
end

think("a")