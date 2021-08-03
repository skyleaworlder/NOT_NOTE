class C
  def initialize
    @v1 = 1
    @v2 = 2
  end
end

class D
  def initialize
    @v1 = 3
    @v2 = 4
  end

  def d1
    puts "@v1 = #{@v1}, @v2 = #{@v2}"
    C.new.instance_eval do
      puts self
      puts "@v1 = #{@v1}, @v2 = #{@v2}"
    end
  end
end

objd = D.new
objd.d1