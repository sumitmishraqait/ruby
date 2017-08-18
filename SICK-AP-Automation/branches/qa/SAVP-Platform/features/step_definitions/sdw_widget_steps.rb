require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'

require 'rspec/expectations'
# include RSpec::Matchers

# require 'rspec'
# require 'rspec/expectations'
#
# RSpec.configure do |config|
  # config.expect_with :rspec do |c|
    # c.syntax = :expect
  # end
# end


# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

Given(/^I am on the default overview dashboard$/) do
  step %[I navigate to "#{$SAVP_Overview_Dashboard_URL}"]
  step %[I wait for 3 sec]
  #step %[I login using valid username "#{$SAVP_Default_Login_Username}" and password "#{$SAVP_Default_Login_Password}"]
end

When(/^I see the SDW for speed data$/) do
  step %[element having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}" should be present]
end

Then(/^I should see a label field and a content field$/) do
  step %[element having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}" should be present]
  step %[element having #{$SDWforSpeedContent.type} "#{$SDWforSpeedContent.value}" should be present]
end

When(/^I click on the label field of SDW for speed data$/) do
  step %[I click on element having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}"]
end


When(/^I enter "([^"]*)" in label field of SDW for speed data$/) do |custom_label|
  $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").send_keys [:control, 'a'] # select all action to highlight text in label field so that it can be replaced with new text
  step %[I enter "#{custom_label}" into input field having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}"]
end

When(/^I click anywhere outside the label field$/) do
  step %[I click on element having #{$SDWforSpeedContent.type} "#{$SDWforSpeedContent.value}"]
end

Then(/^the edited label "([^"]*)" should be saved on clicking outside the label field$/) do |custom_label|
  step %[element having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}" should have attribute "value" with value "#{custom_label}"]
end

Then(/^I should be able to edit the text in label field$/) do
  step %[I enter " - edited" into input field having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}"]
  step %[I click anywhere outside the label field]
  edited_label_text = $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").attribute("value")
  if !edited_label_text.include? " - edited"
    raise TestCaseFailed, 'Edited label text not saved properly.'
  end
end

When(/^I enter a long label like "([^"]*)" in label field of SDW for speed data$/) do |long_custom_label|
  step %[I enter "#{long_custom_label}" in label field of SDW for speed data]
end

Then(/^I should see the truncated label with an ellipsis appended at the end$/)do
  edited_label_text = $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").attribute("value")
  if !edited_label_text.include? " ..."
    raise TestCaseFailed, 'Long label text does not have a trailing ellipsis.'
  end
end

When(/^I try to clear the label field to make it empty$/) do
  step %[I clear input field having #{$SDWforSpeedLabel.type} "#{$SDWforSpeedLabel.value}"]
  step %[I click anywhere outside the label field]
end

Then(/^I should see a snackbar warning that "([^"]*)"$/) do |alert_text|
  step %[I wait for 1 sec]
  step %[element having #{$SDWforSpeedAlert.type} "#{$SDWforSpeedAlert.value}" should be present]
  step %[element having #{$SDWforSpeedAlert.type} "#{$SDWforSpeedAlert.value}" should have text as "#{alert_text}"]
end

When(/^I try to delete all the text in label field to make it empty$/) do
  label_text = $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").attribute("value") # get current label text, calculate total number of characters in it
  label_text.length.times do
    $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").send_keys(:backspace) # hit backspace key that number of times the total length of label text
  end
end

When(/^I try to enter only blank spaces in label field of SDW for speed data$/) do
  $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").send_keys [:control, 'a'] # select all text
  $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").send_keys(:space) # replace highlighted text with a space
end

Then(/^I should not be able to delete the last character$/) do
  label_text = $driver.find_element(:"#{$SDWforSpeedLabel.type}" => "#{$SDWforSpeedLabel.value}").attribute("value")
  if label_text.length != 1
    raise TestCaseFailed, 'Last charater in label text deleted.'
  end
end

When(/^I enter a label "([^"]*)" containing special characters, spaces, numbers & letters in upper\/lower case in label field of SDW for speed data$/) do |free_form_text_label|
  step %[I enter "#{free_form_text_label}" in label field of SDW for speed data]
end
