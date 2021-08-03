v1 = 1
$v2 = 2
@v3 = 3
print "global variables:", global_variables, "\n"
print "local_variables:", local_variables, "\n"
print "instance_variables:", instance_variables, "\n"

module M1
  v4 = 4
  $v5 = 5
  @v6 = 6
  print "M1 scope: local_variables:", local_variables, "instance_variables:", instance_variables, "\n"

  class C1
    v7 = 7
    $v8 = 8
    @v9 = 9
    @@v10 = 10
    print "C1 scope: local_variables:", local_variables, "instance_variables:", instance_variables, "\n"

    def d1
      v11 = 11
      $v12 = 12
      @v13 = 13
      print "d1 scope: local_variables:", local_variables, "instance_variables:", instance_variables, "\n"
    end

    print "C1 scope: local_variables:", local_variables, "instance_variables:", instance_variables, "\n"
  end
end

print "main-upper-scope: local_variables:", local_variables, "instance_variables:", instance_variables, "\n"
c = M1::C1.new
c.d1