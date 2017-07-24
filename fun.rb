#define fun
def fun(*a)
puts "number of parameter in fun is = #{a.length}"
for i in 0...a.length
puts "parameter are: #{a[i]}"
end
end
#calling fun
fun "sumit",6,"a"