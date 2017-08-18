Feature: Testing LDAT License Info RESTful API's methods

  Background:
	Given I am testing a REST API
	  And I am a client

# View license info scenario i.e. GET method scenarios for "config/license" service
  @in_progress
  Scenario Outline: Get information of a valid license with success code 200
    Given I have installed a valid license for LDAT application
    When I send a GET request to "http://10.102.11.228:8080/config/license/info"
      And the response status should be "200"
    Then the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key				 | data_type | value |
		| hasValidKey		 | boolean   | true  |
		| hasValidPermission | boolean   | true  |
		| valid				 | boolean   | true	 |
		| expired			 | boolean   | false |

# Reload license scenario i.e. GET method scenarios for "config/license/reload" service

  Scenario: Reload license information with success code 200
    Given I send a GET request to "http://10.102.11.228:8080/config/license/reload"
    When the response status should be "200"
    Then the JSON response should have "$." of type boolean and value "true"


  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser