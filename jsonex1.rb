require 'json'
array = '[
  {
    "id": 1,
    "name": "Test"
  }
   , 
  {
    "id": 2,
    "name": "Test2"
    
  }
]'

puts JSON.parse(array)