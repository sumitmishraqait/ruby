#Reading json file through hash in ruby
$LOAD_PATH << '.'
require 'json'
file =File.read('C:\\Users\\sumitmishra.QAIT\\Desktop\\RUBYEX\\db.json')
data=JSON.parse(file)
