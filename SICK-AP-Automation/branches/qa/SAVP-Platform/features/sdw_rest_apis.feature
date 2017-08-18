Feature: testing RESTful API used by SDWs in dashboard


  Background:
	Given I am a client
	
# Get a list of all configured systems
  Scenario: Get list of all configured systems with success code 200
    Given I send a GET request to "http://10.102.11.224:8080/system/systemList"
    When the response status should be "200"
    Then the JSON response should have "$." of type array with 64 entries
    
# Get primary statistic for system 01
  Scenario: Get primary statistic for system 01 with success code 200
    Given I send a GET request to "http://10.102.11.224:8080/system/primarystatistics?system=01"
    When the response status should be "200"
    Then the JSON response should have "value" of type string that matches "CLV"

# Get primary statistic's read rate for system 01
  Scenario: Get primary statistic's read rate for system 01 with success code 200
    Given I send a GET request to "http://10.102.11.224:8080/statistics/readrate?statistic=primary&system=01"
    When the response status should be "200"
    Then the JSON response should have "value" of type string that matches "0%"
    And the JSON response should have "info" of type string that matches "-99.9% of expected"

# Get valid object count in current shift for system 01
  Scenario: Get valid object count in current shift for system 01 with success code 200
    Given I send a GET request to "http://10.102.11.224:8080/system/currentshift/validobjects?system=01"
    When the response status should be "200"
    Then the JSON response should have "value" of type string that matches "0" 
     
  Scenario: Print test configuration & close the browser
	Then I print configuration
	Then I close browser