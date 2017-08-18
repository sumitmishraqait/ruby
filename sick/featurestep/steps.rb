require "test/unit/assertions"
include Test::Unit::Assertions
require 'selenium-webdriver'
driver.manage.timeouts.implicit_wait=50
driver=Selenium::WebDriver.for :chrome, :driver_path => 'D:/chromedriver.exe'
