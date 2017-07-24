require 'selenium-webdriver'
if(ENV['browser']=='chrome')
  Selenium::WebDriver::Chrome.driver_path='D:/chromedriver.exe'
  driver=Selenium::WebDriver.for :chrome
elsif (ENV['browser']=='firefox')
  Selenium::WebDriver::Chrome.driver_path='D:/geckodriver.exe'
  driver=Selenium::WebDriver.for :firefox
else
  puts "wrong browser name"
  exit
end

driver.manage.timeouts.implicit_wait=20
Given(/^I am on gmail login page$/) do
driver.navigate.to "http://gmail.com/"

end

When(/^I enter username as username$/) do
driver.find_element(:id,'identifierId').send_keys("sumit.mishra018")
driver.find_element(:id,'identifierNext').click()
end

When(/^password as password$/) do
  driver.find_element(:name,'password').send_keys("9920870091")

end
Then(/^I am at gmail home page$/) do
driver.find_element(:id,'passwordNext').click()
end
