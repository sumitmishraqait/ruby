require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'
require_relative 'property_master.rb'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

# **-> URL of SAVP instance for which the automation scripts will be executed <-**

# ************-> DEFINE LDAT QA INSTANCE URL <-************ #
# IP Address and Port number values can be passed via command line using parameters "IP" and "PORT"
# If IP and PORT values are not passed via command line, by default IP Address: 10.102.11.224 and Port: 8080 will be used

$LDAT_Dashboard_URL = "http://#{$ldat_instance_ip_address}:#{$ldat_instance_port_number}/"

$LDAT_Condifuration_URL = "http://#{$ldat_instance_ip_address}:#{$ldat_instance_port_number}/config"

# ------------------------------------------------------------- #


# **-> Locators for Global Web Elements of System Configuration page <-**

# Username field on Login page
$loginUsername = WebElement.new("id", "undefined--UsernameorEmailaddress-58234")

# Password field on Login page
$loginPassword = WebElement.new("id", "undefined-Password-Password-36752")


# **-> Locators for Global Web Elements of System Landing page <-**




# **-> Locators for Global Web Elements of Devices tab of System Landing page <-**




# **-> Locators for Global Web Elements of Device Groups tab of System Landing page <-**




# **-> Locators for Global Web Elements of Evaluation Conditions tab of System Landing page <-**




# **-> Locators for Global Web Elements of Statistics tab of System Landing page <-**



