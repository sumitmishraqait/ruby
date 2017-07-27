require 'rest_client'
require 'nokogiri'
require 'csv'
require 'selenium-webdriver'
require 'selenium-webdriver'

url="http://computer-database.gatling.io/computers"
    response = RestClient.get(url)
@data  = Nokogiri::HTML(response.body)
    link=@data.css('tbody tr td a')
    link.each do|table|
        puts"#{table.text}"
    end
      @element=link[0].text
  if response.code == 200
  puts "********* Get current user successful"
  else
  puts "Get current user failed!!"
  end
  res=RestClient.get (url+"?f="+@element)
  @resdata= Nokogiri::HTML(res.body)
  li=@resdata.css('tbody tr td a')
  li.each do|table|
      puts"#{table.text}"
  end
  if res.code == 200
  puts "********* ace Get current user successful"
  else
  puts "Get current user failed!!"
  end
resp=RestClient.post url,:name=>"sumit",:introduced=>"2017-07-24",:discontinued=>"2017-07-24",:company=>"5"
@data1  = Nokogiri::HTML(resp.body)
puts"#{@data1}"
if resp.code == 200
puts "********* new Get current user successful"
else
puts "Get current user failed!!"
end
