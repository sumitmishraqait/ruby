require 'selenium-webdriver'
require "test/unit/assertions"
  driver=Selenium::WebDriver.for :chrome, :driver_path => 'D:/chromedriver.exe'
  driver.manage.timeouts.implicit_wait=50
  driver.get "http://10.0.1.86/tatoc"
  sleep 5
    driver.find_element(:xpath=>"//a[contains(@href, 'basic')]").click()
    sleep 5
      @element=driver.find_element(:class,'greenbox').text
      puts "#{@element}"
      sleep 10
      driver.find_element(:class,'greenbox').click();
      puts"clicked green tab"
  assert_equal(@element, "Frame Dungeon - Basic Course - T.A.T.O.C");
