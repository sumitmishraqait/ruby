require "test/unit/assertions"
include Test::Unit::Assertions
require 'selenium-webdriver'
if(ENV['browser']=='chrome')
  driver=Selenium::WebDriver.for :chrome, :driver_path => 'D:/chromedriver.exe'
elsif (ENV['browser']=='firefox')
  Selenium::WebDriver::Chrome.driver_path='D:/geckodriver.exe'
  driver=Selenium::WebDriver.for :firefox
else
  puts "wrong browser name"
  exit
end
@element
@var
driver.manage.timeouts.implicit_wait=50
wait = Selenium::WebDriver::Wait.new(:timeout => 20)


Given(/^I am yahoo finance gainer page$/) do
    driver.get "http://in.finance.yahoo.com/gainers"
    driver.find_element(:xpath=>"//*[@id='portfolio-header']/div/div/div").click()
end

When(/^I click on click on watchlist\-name dropdown$/) do
  puts"I clicked portfolio"
  @element=  driver.find_element(:xpath=>"//*[@id='dropdown-menu']/ul").text
  puts"#{@element}"
end

Then(/^I have dropdown list with following values$/) do |table|
  table.raw.each do |data|
    @var= data.to_s
  end
  assert_equal(@element,@var)
  puts"watch list"
end


When(/^I have selected any option from watchlist\-name$/) do
  driver.find_element(:xpath=>"//*[@id='dropdown-menu']/ul/li[2]/a").click()
  puts"I clicked currency portfolio"
  @element=  driver.find_element(:xpath=>"//*[@id='dropdown-menu']/ul/li[2]/a").text
end

Then(/^I should see the option as selected$/) do
   assert_equal(@element,"Currencies")
   puts"currency title"
end

When(/^I select any option from watchlist\-name$/) do
  driver.find_element(:xpath=>"//*[@id='dropdown-menu']/ul/li[2]/a").click()
  puts"I clicked currency portfolio"
  @element=  driver.find_element(:xpath=>"//*[@id='yfin-list']/div[2]/div/table/thead/tr/th").text
  puts"#{@element}"
end

Then(/^I should see follwing  header for list$/) do |table|
  table.raw.each do |data|
    @cur= data.to_s
  end
  assert_equal(@element,@cur)
  puts"currency header list"
end


When(/^I select mutual fund option$/) do
  driver.find_element(:xpath=>"//*[@id='dropdown-menu']/ul/li[8]").click()
  puts"I clicked Top mutual fund portfolio"
  wait.until { driver.find_element(:xpath=>"//*[@id='Lead-3-YFinListTable-Proxy']/div") }
  @element=  driver.find_element(:xpath=>"//*[@id='Lead-3-YFinListTable-Proxy']/div").text
end

Then(/^I should get error message  "([^"]*)"$/) do |arg1|
  assert_equal(@element,arg1)
  puts"mutual fund msg"
end

When(/^I select currency option$/) do
  driver.find_element(:xpath=>"//*[@id='dropdown-menu']/ul/li[2]/a").click()
  puts"I clicked currency portfolio"
end

When(/^I select any data symbol$/) do
  driver.find_element(:xpath=>"//*[@id='yfin-list']/div[2]/div/table/tbody/tr[1]/td[1]").click()
  puts"I clicked IND/X currency portfolio"
end

Then(/^I should see its following values$/) do |table|
  table.raw.each do |data|
    puts data.to_s
  end
end
