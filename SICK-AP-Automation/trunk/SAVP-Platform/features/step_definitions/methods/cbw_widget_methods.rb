require 'rubygems'

# Do Not Remove This File
# This file contains assertion methods which are called from conveyor_belt_steps.rb

# Method to check if next box is displayed on conveyor belt or not
def convert_color_code_to_rgb(color_hex)
  m = color_hex.match(/#(..)(..)(..)/)
  color_rgb = "rgb(#{m[1].hex}, #{m[2].hex}, #{m[3].hex})"
  return color_rgb
end

# Method to get a list of conditions that will appear as options in color coding dropdown or conditions filter
def get_conditions_from_server
  # back end is not ready yet for this and all the conditions in front end are hard coded
  return list_of_conditions
end

# Method to match the list of conditions returned back end matching them with condition options in color coding dropdown in front end
def match_all_color_coding_conditions_in_dropdown(list_of_conditions)
  # can't be created at this point, too much unknown.
end

# Method to check if a particular color coding condition is present in the drop-down or not
def check_color_coding_condition_presence_in_dropdown(condition)
  # can't be created at this point, too much unknown.
end

# Method to print details of boxes moving on the conveyor belt
def print_details_of_boxes(cb_status)
    old_box_number = 0
    waiting_timeout = 0
    until cb_status == "Inactive"
		conveyor_belt = WAIT.until{ $driver.find_element(:"#{$conveyorBelt.type}" => "#{$conveyorBelt.value}") } # store conveyor belt element for box inspection
		$next_box = WAIT.until{ conveyor_belt.find_element(:"#{$nextBox.type}" => "#{$nextBox.value}") } # store next box element for it's property inspection
		$next_box_prop = WAIT.until{ $next_box.find_element(:"#{$nextBoxProp.type}" => "#{$nextBoxProp.value}") } # store next box property element
        if is_next_box_present # recurring check to see if box is present on belt or not
			if old_box_number < $current_box_number.to_i
				puts $current_box_number.to_i # print box number
				puts $box_properties # print box properties
				puts $box_dimensions # print box dimensions
				old_box_number = $current_box_number.to_i
			end
			step %[I wait for 2 sec] # boxes appear on the belt after a gap of 2 secs -> change this time when using different mock service with lesser or more gap
		else
			puts "No more boxes present on the conveyor belt but the status is still active. Waiting for a box..."
			step %[I wait for 2 sec]
			waiting_timeout +=1;
			if waiting_timeout > 5
				puts "Timing out after 10 seconds of trying to locate next box on conveyor belt even though belt status is still Active."
				break
			end
	    end
		cb_status = WAIT.until{ $driver.find_element(:"#{$cbStatus.type}" => "#{$cbStatus.value}") }.text # recurring check to see if status of conveyor belt is still active or not
	end
	puts "Conveyor belt widget is now Inactive and no more boxes appear on the belt."
end

# Method to store next box's metadata if next box's presence is detected on conveyor belt else handle the other conditions gracefully
def is_next_box_present
  begin
    if is_next_box_displayed
		$current_box_number = $next_box.text # get current box number
		$box_dimensions = $next_box.attribute("style") # store box dimensions
		$box_properties = $next_box_prop.attribute("style") # store box properties
		return true
    end
    rescue Exception => e
		if e.message.include?("Unable to locate element") || e.message.include?("no such element") || e.message.include?("timed out after 30 seconds")	# Each browser throws a different error when an element is not found. Checking not found scenario for each Chrome, FF & IE11
			return false
		elsif e.message.include?("stale element reference") || e.message.include?("element is not attached to the page document") || e.message.include?("Element is no longer attached to the DOM")# this happens when the box is out of bound even before selenium could read it's attributes. Also, Each browser throws a different error when an element is not found. Checking DOM not attached scenario for each Chrome, FF & IE11
			puts "Couldn't read details of next box due to - \"element is not attached to DOM\" error... probable causes could be that the boxes are overlapping or parallel or too colse i.e. less/ no gap between boxes. Refreshing the webpage to resolve DOM error"
			step %[I refresh page] # refreshing the webpage to resolve the DOM error
			step %[I wait for 2 sec] # wait for a second for page to refresh
			return false
		else
			puts e.message
			puts "Unexpected error or webdriver session timed out. Refer to captured exception text."
			raise TestCaseFailed, 'Unexpected error.'
			return false
		end
	end
end

# **-> APIs/ METHODS BELOW THIS POINT ARE USED IN METHODS ABOVE <-**

# Method to check if next box is displayed on conveyor belt or not
def is_next_box_displayed
  $next_box.displayed? # check if next box is displayed in case cb_status condition is Active but box_present_on_conveyor is false in until loop i.e. only one condition met so loop will still run
end