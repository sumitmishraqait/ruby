require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

When(/^I see the Activity Table widget$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see the title of ATW as "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see a button to toggle ATW between Play\/Pause modes$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I see the Activity Table widget in (Play|Pause) mode$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see new objects (stops|starts) buffering in ATW$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see a (Pause|Resume) button to toggle ATW to (Pause|Play) mode$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I push test data with more than (\d+) objects$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see only last (\d+) objects in ATW$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the activity of objects older than (\d+)th object is removed from ATW$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I click on the edit columns button in ATW$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see data point (Item ID|Time stamp|Conditions|Devices|Barcodes|Dimensions \(LxWxH\)|Scale data \(Weight\)|Host message) checked by default in edit columns modal window$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I uncheck column "([^"]*)" in edit columns modal window and save$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should not see "([^"]*)" column in ATW$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I cannot uncheck column "([^"]*)" in edit columns modal window and save$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I uncheck column "([^"]*)" in edit columns modal window and cancel$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should still see "([^"]*)" column in ATW$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the save button should be inactive\/grayed out by default$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I set the unit configuration to "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see (dimensions|scale data) in "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I hover my mouse over the content entry in first row of "([^"]*)" column$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see the full content of that column entry in a tool tip$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I rearrange the order of column "([^"]*)" and move it to the (top|end) of the list$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the "([^"]*)" column becomes the (right\-most|left\-most) column in ATW$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see the button to filter object activity by conditions$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I click on the filter by condition drop\-down$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see all available conditions with check\-boxes in the drop\-down$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should not see the button to filter object activity by conditions$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I select "([^"]*)" conditions from filter by confitions drop\-down$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see only those objects in ATW that meets all the selected conditions$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the previous object activity gets cleared and filtered object activity starts streaming$/) do
  pending # Write code here that turns the phrase above into concrete actions
end