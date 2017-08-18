require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'

# Do Not Remove This File

# **-> WEB ELEMENT CLASS DEFINITION STARTS <-**
# Parent class for initializing Web Element parameters.
# A new Object of this class should be created for defining each web element.

class WebElement
   attr_reader :type, :value
   def initialize(elem_type, elem_value)
      validate_locator elem_type
      @type=elem_type
      @value=elem_value
   end
end

# Method to validate the type of locator
def valid_locator_type? type
  %w(id class css name xpath).include? type
end

# Method to validate locator of web element object
def validate_locator type
  raise "Invalid locator type - #{type}" unless valid_locator_type? type
end

# **-> WEB ELEMENT CLASS DEFINITION ENDS <-**

# Defining a local HTML page path to be launched in case of Non-UI testing
$SELCUKE_TEST_IN_PROGRESS = "http://10.102.11.196/js/index.html"