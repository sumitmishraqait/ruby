require 'mongo'

db = Mongo::Client.new([ 'localhost:27017' ], :database => 'mydb')
coll = db.collections("testCollection")
doc = {"name" => "MongoDB", "type" => "database", "count" => 1,
       "info" => {"x" => 203, "y" => '102'} }
coll.insert(doc)
