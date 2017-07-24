class First

def initialize(id,name)
@first_id=id;
@first_name=name;
end
def printFirst()
puts "ID:#@first_id";
puts "NAME:#@first_name";
public :printFirst() 
end
end


obj=First.new(1,"sumit mishra")