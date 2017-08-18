Feature: Testing IL Core condition configuration RESTful API's methods
# pending - adding scenarios for disabled conditions in drop-down and condition configuration page

  Background:
	Given I am testing a REST API
	  And I am a client
	  And I reset system configuration of following server:
	  	| table		 | system  		 |
	  	| keyspace	 | sick_il		 |
	  	| ip_address | 10.102.11.228 |
      And I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|

# View Condition scenarios i.e. GET method scenarios for "config/system/01/condition" service

  Scenario Outline: Get list of all configured conditions after adding two conditions with success code 200
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |
      And I add another new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | Camera	 |
		| conditionLevel | BLC		 |
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/condition"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 2 entries
      And the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key		 | data_type | value	 |
		| $[0].name	 | string    | ValidRead |
		| $[0].level | string    | OLC 		 |
		| $[1].name	 | string    | Camera	 |
		| $[1].level | string    | BLC 		 |


# Add Condition scenarios i.e. POST method scenarios for "config/system/01/condition" service

  Scenario: Try to add a new condition with bad/empty request should return response code 400
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "400"

  Scenario: Try to add a new condition with invalid request containing bad parameters should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "Camera<&>",
			"level": "BLC"
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid"

  Scenario: Try to add a new condition with invalid request missing mandatory parameter - condition name should return response code 412
    Given I set JSON request body to:
	   """
		{
			"level": "BLC"
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Condition name and/or condition level is missing"  

  Scenario: Try to add a new condition with invalid request missing mandatory parameter - condition level should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "Camera"
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Condition name and/or condition level is missing"

  Scenario: Try to add a new condition with invalid request containing bad parameters in condition level field should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "Camera",
			"level": "TLC"
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid"

  Scenario: Try to add a new condition with invalid request containing non-unique value for a mandatory parameter condition name that requires unique value should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |
    When I set JSON request body to:
	   """
		{
			"name": "ValidRead",
			"level": "BLC"
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Condition ValidRead already exists in the system 01"

  Scenario: Try to add a new condition with invalid request containing spaces should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": " Valid Weight ",
			"level": "OLC"
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid" 
              
  Scenario: Try to add a new condition with valid request should return response code 201
    Given I set JSON request body to:
	   """
		{
			"name": "Camera",
			"level": "BLC"
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "201"


 # Edit Condition scenarios i.e. PUT method scenarios for "config/system/01/condition" service

  Scenario: Try to edit an existing condition with bad/empty request should return response code 400
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "400" 

  Scenario: Try to edit an existing condition with invalid request containing group name with bad parameters should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01	  	 |
		| systemName	 | 01	  	 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC	  	 |
    When I set JSON request body to:
	   """
		{
			"name": "ValidRead",
			"level": "BLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Valid<&>Read"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid"
  
  Scenario: Try to edit an existing condition with invalid request containing bad parameters should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01	  |
		| systemName	 | 01	  |   
		| conditionName	 | Camera |
		| conditionLevel | OLC	  |
    When I set JSON request body to:
	   """
		{
			"name": "Camera<&>",
			"level": "BLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid"

  Scenario: Try to edit an existing condition with invalid request missing mandatory parameter - condition name should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01	  |
		| systemName	 | 01	  |   
		| conditionName	 | Camera |
		| conditionLevel | OLC	  |
    When I set JSON request body to:
	   """
		{
			"level": "BLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Condition name and/or condition level is missing"  

  Scenario: Try to edit an existing condition with invalid request missing mandatory parameter - condition level should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01	  |
		| systemName	 | 01	  |   
		| conditionName	 | Camera |
		| conditionLevel | OLC	  |
    When I set JSON request body to:
	   """
		{
			"name": "Camera"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Condition name and/or condition level is missing" 

  Scenario: Try to edit an existing condition with invalid request containing bad parameters in condition level field should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01	  |
		| systemName	 | 01	  |   
		| conditionName	 | Camera |
		| conditionLevel | OLC	  |
    When I set JSON request body to:
	   """
		{
			"name": "Camera",
			"level": "TLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid"

  Scenario: Try to edit an existing condition with invalid request containing non-unique value for a mandatory parameter condition name that requires unique value should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |
      And I add another new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | Camera	 |
		| conditionLevel | BLC		 |
    When I set JSON request body to:
	   """
		{
			"name": "ValidRead",
			"level": "BLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Condition ValidRead already exists in the system 01"

  Scenario: Try to edit an existing condition with invalid request containing spaces should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |
    When I set JSON request body to:
	   """
		{
			"name": " Valid Weight ",
			"level": "OLC"
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/ValidRead"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid" 

  Scenario: Try to edit an existing condition with valid request should return response code 200
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |
    When I set JSON request body to:
	   """
		{
			"name": "Camera",
			"level": "BLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/ValidRead"
    Then the response status should be "200"

 # Delete Condition scenarios i.e. DELETE method scenarios for "config/system/01/condition" service  

  Scenario: Try to delete a non-existing condition should return response code 404
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |  
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "404"

  Scenario: Try to delete a condition with invalid request containing condition name with bad parameters should return response code 412
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |  
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/condition/Valid<&>Read"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "condition not valid"
 
  Scenario: Try to delete an existing condition with valid request & verify condition is deleted with response code 200    
    Given I add a new condition with following configuration:
		| facilityId	 | 01		 |
		| systemName	 | 01		 |   
		| conditionName	 | ValidRead |
		| conditionLevel | OLC		 |  
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/condition/ValidRead"
    Then the response status should be "200"    
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the JSON response should have "$." of type array with 0 entries


# Negative scenarios i.e. trying methods that are not allowed with certain url for "config/system/01/condition" service

  Scenario: Try to call POST with incorrect url should return response code 405
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'POST' not supported" 

  Scenario: Try to call PUT with incorrect url should return response code 405
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'PUT' not supported" 
 
  Scenario: Try to call DELETE with incorrect url should return response code 405
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/condition"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'DELETE' not supported"
    
  @teardown
  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser    