require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

When(/^I open the color coding settings of Conveyor Belt widget$/) do
  step %[I wait for 1 sec]
  step %[I click on element having #{$cbwSettingsButton.type} "#{$cbwSettingsButton.value}"]
  step %[I wait for 1 sec]
  step %[element having #{$cbwSettingsModal.type} "#{$cbwSettingsModal.value}" should be present]
  step %[I click on element having #{$cbwSettingsColorCodingTab.type} "#{$cbwSettingsColorCodingTab.value}"]
end

Then(/^I should see pre\-defined (.+) color with code "([^"]*)" in it$/) do |color_name, color_code|
  color_code_in_rgb = convert_color_code_to_rgb(color_code)
  if color_name == "green"
    step %[element having #{$colorCodingColor.type} "#{$colorCodingColor.value[0]}" should have attribute "background-color" with value "#{color_code_in_rgb}"]
  elsif color_name == "orange"
    step %[element having #{$colorCodingColor.type} "#{$colorCodingColor.value[1]}" should have attribute "background-color" with value "#{color_code_in_rgb}"]
  elsif color_name == "red"
    step %[element having #{$colorCodingColor.type} "#{$colorCodingColor.value[2]}" should have attribute "background-color" with value "#{color_code_in_rgb}"]
  elsif color_name == "blue"
    step %[element having #{$colorCodingColor.type} "#{$colorCodingColor.value[3]}" should have attribute "background-color" with value "#{color_code_in_rgb}"]
  else
    puts "Please recheck step. Only green, orange, red & blue can be used as valid color names in this step for now."
    raise TestCaseFailed, 'Incorrect color name specified in Step'
  end
end

Then(/^I should see a drop\-down of all available Conditions next to (.+) color with code "([^"]*)"$/) do |color_name, color_code|
  list_of_conditions = get_conditions_from_server # pending - can't write code until previous steps can be executed and application's back end is built and behavior is determined
  if color_name == "green"
    step %[option "None" by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}" should be selected]
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}"]
    match_all_color_coding_conditions_in_dropdown(list_of_conditions) # pending - can't write code until... same reason as above
  elsif color_name == "orange"
    step %[option "None" by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}" should be selected]
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}"]
    match_all_color_coding_conditions_in_dropdown(list_of_conditions) # pending - can't write code until... same reason as above
  elsif color_name == "red"
    step %[option "None" by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}" should be selected]
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}"]
    match_all_color_coding_conditions_in_dropdown(list_of_conditions) # pending - can't write code until... same reason as above
  elsif color_name == "blue"
    step %[option "None" by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}" should be selected]
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}"]
    match_all_color_coding_conditions_in_dropdown(list_of_conditions) # pending - can't write code until... same reason as above
  else
    puts "Please recheck step. Only green, orange, red & blue can be used as valid color names in this step for now."
    raise TestCaseFailed, 'Incorrect color name specified in Step'
  end
end

Given(/^I am on the color coding settings of Conveyor Belt widget$/) do
  step %[I am on the default overview dashboard]
  step %[I open the color coding settings of Conveyor Belt widget]
end

When(/^I select a condition "([^"]*)" from drop\-down menu of (.+) color$/) do |condition, color|
  if color == "green"
    step %[I select "#{condition}" option by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}"]
  elsif color == "orange"
    step %[I select "#{condition}" option by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}"]
  elsif color == "red"
    step %[I select "#{condition}" option by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}"]
  elsif color == "blue"
    step %[I select "#{condition}" option by text from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}"]
  else
    puts "Please recheck step. Only green, orange, red & blue can be used as valid color names in this step for now."
    raise TestCaseFailed, 'Incorrect color name specified in Step'
  end
end

Then(/^I should not see "([^"]*)" condition as a drop\-down menu of any color other than (.+)$/) do |condition, color|
  if color == "green"
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
  elsif color == "orange"
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
  elsif color == "red"
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
  elsif color == "blue"
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
    step %[I click on element having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}"]
    check_color_coding_condition_presence_in_dropdown(condition) # pending - can't write code until... same reason as above
  else
    puts "Please recheck step. Only green, orange, red & blue can be used as valid color names in this step for now."
    raise TestCaseFailed, 'Incorrect color name specified in Step'
  end
end

When(/^I set a condition for (.+) color$/) do |color| # can contain just a color name or color name with prefix "only"
  if color.include? "only " # check if the prefix only is present in the attribute color passed through the step
   color.slice! "only " # remove the prefix only from color if present
  end
  if color == "green"
    step %[I select 1 option by index from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[0]}"]
  elsif color == "orange"
    step %[I select 1 option by index from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[1]}"]
  elsif color == "red"
    sstep %[I select 1 option by index from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[2]}"]
  elsif color == "blue"
    step %[I select 1 option by index from dropdown having #{$colorCodingSelection.type} "#{$colorCodingSelection.value[3]}"]
  else
    puts "Please recheck step. Only green, orange, red & blue can be used as valid color names with/without prefix \"only\" in this step for now."
    raise TestCaseFailed, 'Incorrect color name specified in Step'
  end
end

Then(/^I should be able to set a condition for (.+) color$/) do |color|
  step %[I set a condition for #{color} color]
end

Given(/^I set conditions for all the colors in Conveyor Belt widget's color coding settings$/) do
  step %[I set a condition for green color]
  step %[I set a condition for orange color]
  step %[I set a condition for red color]
  step %[I set a condition for blue color]
end

When(/^I receive a box on CBW that meets multiple color coding conditions$/) do
  pending # Write a method to push test data with meeting multiple conditions. Re-use the dacq_integration_test feature test scenario to achieve this
end

Then(/^I should see the box in topmost color in color coding settings$/) do
  pending # Write a method to retrieve color of a particular box and check if it set according the conditions priority
end

Then(/^I should sill be able to save the color conditions$/) do
  step %[element having #{$cbwSettingsSaveButton.type} "#{$cbwSettingsSaveButton.value}" should be enabled]
  step %[I click on element having #{$cbwSettingsSaveButton.type} "#{$cbwSettingsSaveButton.value}"]
end

When(/^I see the "([^"]*)" widget$/) do |widget_name|
	step %[I wait for 1 sec]
	if widget_name == "Conveyor Belt"
		step %[element having #{$conveyorBelt.type} "#{$conveyorBelt.value}" should be present]
	else
		puts "Incorrect widget name specified in the step"
	end
end

And(/^I print number & attributes of the boxes on the belt$/) do
	convyr_belt_status = WAIT.until{ $driver.find_element(:"#{$cbStatus.type}" => "#{$cbStatus.value}") }.text # initial status of conveyor belt
	box_presence =  is_element_present("#{$boxPresence.type}","#{$boxPresence.value}") # first time check to see if any box is present
	if !box_presence && convyr_belt_status == "Inactive"
		puts "Conveyor belt widget is Inactive and no box is present on the belt"
	else
		print_details_of_boxes convyr_belt_status
	end
end