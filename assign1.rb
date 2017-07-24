#class B contain function show
class B
def show()
puts"This is class B "
end
end

#module C contain Function show
module C

def C.show()
puts"This is module C"
end
end


#class A inhert B and Include Module C

class A < B
include C
def show type
if type.kind_of? Class
	B.new.show()
elsif type.kind_of? Module
	C.show()
else
end
end
end


#object 

obj=A.new
obj.show(B)
obj.show(C)
 
