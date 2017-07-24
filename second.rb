class First

def initialize(id,name)
@first_id=id;
@first_name=name;
end
def printFirst()
puts "ID:#@first_id";
puts "NAME:#@first_name";

end
end

class Second < First
def printSecond()
puts"this is second class inhert first class"
end
end

#object
obj=Second.new(1,"sumit mishra")
obj.printFirst()
obj.printSecond()
