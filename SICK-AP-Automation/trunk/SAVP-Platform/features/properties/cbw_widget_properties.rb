require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'
require_relative 'property_master.rb'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

# **-> Default Login credentials of SAVP instance for execution for CBW feature tests <-**

# Default username to be used by automation scripts for CBW feature tests is "admin"
# Default password to be used by automation scripts for CBW feature tests is "sicksick"

$SAVP_Default_Login_Username = "admin"

$SAVP_Default_Login_Password = "sicksick"

# ------------------------------------------------------------- #

# **-> Locators for Global Web Elements of Conveyor Belt Widget <-**

# Welcome message in the header
$conveyorBelt = WebElement.new("xpath", ".//*[@id='conveyor-belt']/div/div[2]/div[1]")

$cbStatus = WebElement.new("xpath", ".//*[@id='conveyor-belt']/div/div[1]/div[2]/div[1]/div")

$boxPresence = WebElement.new("xpath", "//div[starts-with(@id,'SICKConveyorBeltItem-')]")

$nextBox = WebElement.new("css", "div")

$nextBoxProp = WebElement.new("css", "div")

$cbwSettingsButton = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[2]/div/div[1]/div/div/div/div[1]/div[2]/button")

$cbwSettingsModal = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/h3")

$cbwSettingsMetricsTab = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[1]/div/div[1]/button[1]")

$cbwSettingsPerspectiveTab = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[1]/div/div[1]/button[2]")

$cbwSettingsColorCodingTab = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[1]/div/div[1]/button[3]")

$colorCodingColor = WebElement.new("xpath", ['html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[2]/div[1]', 'html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[3]/div[1]', 'html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[4]/div[1]', 'html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[5]/div[1]'])

$colorCodingSelection = WebElement.new("xpath", ['html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[2]/div[2]/div[1]/div[2]', 'html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[3]/div[2]/div[1]/div[2]', 'html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[4]/div[2]/div[1]/div[2]', 'html/body/div[2]/div/div[1]/div/div/div[1]/div/div[3]/div[3]/div[5]/div[2]/div[1]/div[2]'])

$cbwSettingsSaveButton = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[2]/div/button")

$cbwSettingsCancelButton = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[2]/button")