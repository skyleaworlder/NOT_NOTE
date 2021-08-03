class A
  def initialize
    @v1, @v2 = 1, 2
  end

  def get_v1
    return @v1
  end

  def get_v2
    return @v2
  end
end

obja = A.new

cnt = 0
2.times do
  cnt = cnt + 1
  v_tmp = obja.method ("get_v"+cnt.to_s).to_sym
  print "@v"+cnt.to_s+": ", v_tmp.call, "\n"
end