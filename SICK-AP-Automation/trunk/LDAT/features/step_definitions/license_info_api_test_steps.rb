require 'selenium-cucumber'
require 'cucumber-rest-bdd'
require 'cucumber-api'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

Given(/^I have installed (a valid|an invalid|an expired|no) license for LDAT application$/) do |license_type|
  # Write code here to place/replace license file in application's installation directory with a desired one for testing.
  # Dev will build a REST API in future to place the license file and that should be used under this step, for now it is just a dummy step
  # this will always assume that the license is valid and is placed in the installation directory of application under test
end