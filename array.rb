
puts"enter n:"
n=gets.to_i
array=Array.new(n)
puts"#{array.size}"
for i in (0...n)
puts"insert #{i} element in array"
array.insert(i,gets.to_i)
end
for i in 0...n
print"#{array[i]} "
end


#sort array
for i in 0...n
key=array[i]
j=i-1
while j>=0 && array[j]> key
array[j+1]=array[j]
j=j-1
end
array[j+1]=key
end

#array.sort
puts"\n"
puts "sorted array is:"
for i in 0...n
print"#{array[i]}  "
end