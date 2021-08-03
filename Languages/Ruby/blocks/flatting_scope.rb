v1 = 1

A = Class.new do
  define_method :get_v do
    return v1
  end
end

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

obja = A.new
objc = C.new
print obja.get_v, "\n"
print objc.get_v, "\n"
print objc.get_name, "\n"