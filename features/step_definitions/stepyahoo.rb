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
wait = Selenium::WebDriver::Wait.new(:timeout => 15)
Given(/^I am on yahoo finance stock gainer page$/) do
driver.navigate.to "https://in.finance.yahoo.com/gainers"
end

When(/^I click on BSE Sensor$/) do
driver.find_elements(:css, '.Cur(p).Fw(b).Fz(16px)').click()
end

Then(/^I have market opening detail$/) do


end
