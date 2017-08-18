require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'
require_relative 'property_master.rb'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

# **-> Locators for Global Web Elements of SDW for Speed data <-**

# SDW for Speed
$SDWforSpeed = WebElement.new("xpath", ".//*[@id='il-sdw-speed']/div/div[1]")

# SDW title/label field for Speed
$SDWforSpeedLabel = WebElement.new("xpath", ".//*[@id='il-sdw-speed']/div/div[1]/div[1]/input[starts-with(@id, 'title-textfield-undefined-undefined-')]")

# SDW content field for Speed
$SDWforSpeedContent = WebElement.new("xpath", ".//*[@id='il-sdw-speed']/div/div[1]/div[2]/div")

# SDW snackbar alert for Speed
$SDWforSpeedAlert = WebElement.new("xpath", ".//*[@id='il-sdw-speed']/div/div[2]/div/div/span")
