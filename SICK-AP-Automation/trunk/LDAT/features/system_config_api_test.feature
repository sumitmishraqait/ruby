Feature: Testing IL Core System configuration RESTful API's methods
# pending - adding scenarios for disabled systems in drop-down and system configuration page

  Background:
	Given I am testing a REST API
	  And I am a client
	  And I reset system configuration of following server:
	  	| table		 | system  		 |
	  	| keyspace	 | sick_il		 |
	  	| ip_address | 10.102.11.228 |

# View System scenarios i.e. GET method scenarios for "config/system" service

  Scenario: Get list of all configured systems after adding two systems with success code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|
      And I add another new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 02		|
		| systemLabel					| System 02 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a GET request to "http://10.102.11.228:8080/config/system"
      And the response status should be "200"
    Then the JSON response should have "systemList" of type array with 2 entries
      And the JSON response should have "totalSystemNumber" of type numeric and value "2"
      And the JSON response should have "numberOfSystemAllowed" of type numeric and value "64"

  Scenario: Get configuration of a specific system that doesn't exist should return response code 404
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 03		|
		| systemLabel					| System 03 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|
    When I send a GET request to "http://10.102.11.228:8080/config/system/044"
      And the response status should be "404"
    Then the JSON response should have "error" of type string that matches "Not Found"
      And the JSON response should have "message" of type string that matches "The system name 044 cannot be found in database"

  Scenario Outline: Get configuration of a specific system that exist should return response code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a GET request to "http://10.102.11.228:8080/config/system/04"
      And the response status should be "200"
    Then the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key							| data_type    | value		|
		| facilityId					| string       | 01			|
		| systemName					| string       | 04			|
		| systemLabel					| string       | System 04  |
		| minReadCycles					| numeric      | 1000		|
		| movingAverageLength			| numeric      | 7			|
		| noreadThreshold				| numeric      | 4			|
		| movingAverageWarningThreshold | numeric      | 2.8		|
		| disabled      				| boolean      | false		|


# Add System scenarios i.e. POST method scenarios for "config/system" service

  Scenario: Try to add a new system with bad/empty request should return response code 400
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "400"

  @no_license
  Scenario: Try to add a new system apart from first two systems with no license should return response code 412
    Given I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "01",
			"systemLabel": "System 01",
			"minReadCycles": 900,
			"noreadThreshold": 10,
			"movingAverageLength": 5,
			"movingAverageWarningThreshold": 3.5
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Can not add another system due to license restrictions"

  @no_license
  Scenario: Try to add a new system as one of the first two systems with no license should return response code 201
    Given I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "01",
			"systemLabel": "System 01",
			"minReadCycles": 900,
			"noreadThreshold": 10,
			"movingAverageLength": 5,
			"movingAverageWarningThreshold": 3.5
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "201"
    
  @expired_license
  Scenario: Try to add a new system apart from first two systems with expired license should return response code 412
    Given I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "02",
			"systemLabel": "System 02",
			"minReadCycles": 500,
			"noreadThreshold": 7,
			"movingAverageLength": 3,
			"movingAverageWarningThreshold": 4.6
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Can not add another system due to license restrictions"

  @expired_license
  Scenario: Try to add a new system as one of the first two systems with expired license should return response code 201
    Given I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "02",
			"systemLabel": "System 02",
			"minReadCycles": 500,
			"noreadThreshold": 7,
			"movingAverageLength": 3,
			"movingAverageWarningThreshold": 4.6
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "201"

  Scenario: Try to add a new system apart from first two systems with invalid request containing bad parameters should return response code 412
    Given I set JSON request body to:
	   """
		{
			"systemName": "0<>&3",
			"systemLabel": "System 03",
			"minReadCycles": 990,
			"noreadThreshold": 12,
			"movingAverageLength": 4,
			"movingAverageWarningThreshold": 1.9
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The system name is invalid."

  Scenario: Try to add a new system apart from first two systems with invalid request missing mandatory parameters should return response code 412
    Given I set JSON request body to:
	   """
		{
			"systemLabel": "System 03",
			"minReadCycles": 990,
			"noreadThreshold": 12,
			"movingAverageLength": 4,
			"movingAverageWarningThreshold": 1.9
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The system name is invalid."

  Scenario: Try to add a new system with invalid request containing non-unique value for a mandatory parameter system name that requires unique value should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 03		|
		| systemLabel					| System 03 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "03",
			"systemLabel": "System 04",
			"minReadCycles": 1000,
			"noreadThreshold": 4,
			"movingAverageLength": 7,
			"movingAverageWarningThreshold": 2.8
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "System 03 alread exists"

  Scenario Outline: Try to add a new system with invalid request containing bad parameters should return response code 412
    Given I set JSON request body to:
	   """
		<payload_json>
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The system request contains invalids params."
      And I clear the response cache
		Examples:
		| payload_json |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03 - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque convallis feugiat sapien non dapibus. Nunc nisl diam, auctor vel sem eget, laoreet eleifend massa. In ante augue, elementum sed condimentum ac, congue quis risus. In sed diam arcu.","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 0,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1000,"noreadThreshold": 0,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 1000,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 0,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 366,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 100.01} |

  Scenario Outline: Try to add a new system with invalid request containing leading/trailing spaces should return response code 412
    Given I set JSON request body to:
	   """
		<payload_json>
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "<message>"
      And I clear the response cache
		Examples:
		| payload_json | message |
		| {"facilityId": "01","systemName": " 03 ","systemLabel": "System 03","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} | The system name is invalid. |
		| {"facilityId": "01","systemName": "03","systemLabel": " System 03 ","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} | The system request contains invalids params. |
				
  Scenario: Try to add a new system with valid request & license should return response code 201
    Given I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "03",
			"systemLabel": "System 03",
			"minReadCycles": 990,
			"noreadThreshold": 12,
			"movingAverageLength": 4,
			"movingAverageWarningThreshold": 1.9
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "201"

  Scenario: Try to add a new system apart from first two systems with valid request & license should return response code 201    
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|
      And I add another new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 02		|
		| systemLabel					| System 02 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "03",
			"systemLabel": "System 03",
			"minReadCycles": 990,
			"noreadThreshold": 12,
			"movingAverageLength": 4,
			"movingAverageWarningThreshold": 1.9
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "201"
    
  Scenario Outline: Try to add new systems with valid requests with system names containing leading zeroes should return response code 201
    Given I set JSON request body to:
	   """
		<payload_json>
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "201"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system"
      And the response status should be "200"
    Then the JSON response should have "$.systemList[0].systemName" of type string and value "<system_name>"
		Examples:
		| payload_json | system_name |
		| {"facilityId": "01","systemName": "1","systemLabel": "System 1","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} | 1 |
		| {"facilityId": "01","systemName": "01","systemLabel": "System 01","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} | 01 |
		| {"facilityId": "01","systemName": "001","systemLabel": "System 01","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} | 001 |
		| {"facilityId": "01","systemName": "0001","systemLabel": "System 01","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} | 0001 |


# Edit System scenarios i.e. PUT method scenarios for "config/system" service

  Scenario: Try to edit an existing system with bad/empty request should return response code 400
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a PUT request to "http://10.102.11.228:8080/config/system/04"
    Then the response status should be "400"

  @no_license
  Scenario: Try to edit an existing system that got disabled due to no license should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 999		|
		| noreadThreshold				| 11		|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 6.7		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "01 EDIT",
			"systemLabel": "System 01 edited the @label",
			"minReadCycles": 900,
			"noreadThreshold": 10,
			"movingAverageLength": 5,
			"movingAverageWarningThreshold": 3.5
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Can not edit system due to license restrictions"

  @no_license
  Scenario: Try to edit an existing system from first two active systems with no license should return response code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 999		|
		| noreadThreshold				| 11		|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 6.7		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "01 EDIT",
			"systemLabel": "System 01 edited the @label",
			"minReadCycles": 900,
			"noreadThreshold": 10,
			"movingAverageLength": 5,
			"movingAverageWarningThreshold": 3.5
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01"
    Then the response status should be "200"

  @expired_license
  Scenario: Try to edit an existing system that got disabled due to expired license should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 02		|
		| systemLabel					| System 02 |
		| minReadCycles					| 569		|
		| noreadThreshold				| 22		|		
		| movingAverageLength			| 8			|
		| movingAverageWarningThreshold | 5.4		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "02 @ed!t",
			"systemLabel": "System 02 - edited l@b3l",
			"minReadCycles": 500,
			"noreadThreshold": 7,
			"movingAverageLength": 3,
			"movingAverageWarningThreshold": 4.6
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/02"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Can not edit system due to license restrictions"   

  @expired_license
  Scenario: Try to edit an existing system from first two systems with expired license should return response code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 02		|
		| systemLabel					| System 02 |
		| minReadCycles					| 569		|
		| noreadThreshold				| 22		|		
		| movingAverageLength			| 8			|
		| movingAverageWarningThreshold | 5.4		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "02 @ed!t",
			"systemLabel": "System 02 - edited l@b3l",
			"minReadCycles": 500,
			"noreadThreshold": 7,
			"movingAverageLength": 3,
			"movingAverageWarningThreshold": 4.6
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/02"
    Then the response status should be "200"

  Scenario: Try to edit an existing system with invalid request containing system name with bad parameters should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a PUT request to "http://10.102.11.228:8080/config/system/0<>&4"
      And the response status should be "412"
    Then the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The system name 0<>&4 is not valid" 

  Scenario: Try to edit an existing system with invalid request containing prohibited XML characters in system name should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 03		|
		| systemLabel					| System 03 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "0<>&3",
			"systemLabel": "System 03 edited label",
			"minReadCycles": 1001,
			"noreadThreshold": 1001,
			"movingAverageLength": 366,
			"movingAverageWarningThreshold": 100.1
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/03"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The system name is invalid."

  Scenario: Try to edit an existing system with invalid request with invalid request missing mandatory parameters should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemLabel": "System 04",
			"minReadCycles": 1000,
			"noreadThreshold": 4,
			"movingAverageLength": 7,
			"movingAverageWarningThreshold": 2.8
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/04"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The system name is invalid."

  Scenario Outline: Try to edit an existing system with invalid request containing bad parameters should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 03		|
		| systemLabel					| System 03 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		|
    When I set JSON request body to:
	   """
		<payload_json>
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The system request contains invalids params."
      And I clear the response cache
		Examples:
		| payload_json |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03 - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque convallis feugiat sapien non dapibus. Nunc nisl diam, auctor vel sem eget, laoreet eleifend massa. In ante augue, elementum sed condimentum ac, congue quis risus. In sed diam arcu.","minReadCycles": 1000,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 0,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1000,"noreadThreshold": 0,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 1000,"movingAverageLength": 7,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 0,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 366,"movingAverageWarningThreshold": 2.8} |
		| {"facilityId": "01","systemName": "03","systemLabel": "System 03","minReadCycles": 1001,"noreadThreshold": 4,"movingAverageLength": 7,"movingAverageWarningThreshold": 100.01} |

  Scenario Outline: Try to edit an existing system with valid request & verify that edited values reflect in system configuration with response code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "04-edited",
			"systemLabel": "System_04",
			"minReadCycles": 900,
			"noreadThreshold": 10,
			"movingAverageLength": 5,
			"movingAverageWarningThreshold": 3.5
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/04"
    Then the response status should be "200"
    Given I send a GET request to "http://10.102.11.228:8080/config/system/04-edited"
    When the response status should be "200"
    Then the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key							| data_type    | value		|
		| facilityId					| string       | 01			|
		| systemName					| string       | 04-edited	|
		| systemLabel					| string       | System_04  |
		| minReadCycles					| numeric      | 900		|
		| movingAverageLength			| numeric      | 5			|
		| noreadThreshold				| numeric      | 10			|
		| movingAverageWarningThreshold | numeric      | 3.5		|
		| disabled      				| boolean      | false		|

  Scenario: Try to edit an existing system with invalid request containing non-unique value for a mandatory parameter that requires unique value should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 03		|
		| systemLabel					| System 03 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		| 
      And I add another new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I set JSON request body to:
	   """
		{
			"facilityId": "01",
			"systemName": "03",
			"systemLabel": "System 03",
			"minReadCycles": 900,
			"noreadThreshold": 10,
			"movingAverageLength": 5,
			"movingAverageWarningThreshold": 3.5
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/04"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "System 03 already exists"


# Delete System scenarios i.e. DELETE method scenarios for "config/system" service

  @no_license
  Scenario: Try to delete an existing system that got disabled due to no license should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 999		|
		| noreadThreshold				| 11		|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 6.7		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01"
      And the response status should be "412"
    Then the JSON response should have "systemList" of type array with 1 entries
      And the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The system name 01 is not permitted by the license, please check info by visiting \"/license/info\"" 
        
  @no_license
  Scenario: Try to edit an existing system from first two active systems with no license should return response code 200 
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 01		|
		| systemLabel					| System 01 |
		| minReadCycles					| 999		|
		| noreadThreshold				| 11		|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 6.7		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01"
      And the response status should be "200"
    Then the JSON response should have "systemList" of type array with 0 entries
      And the JSON response should have "totalSystemNumber" of type numeric and value "0"
      And the JSON response should have "numberOfSystemAllowed" of type numeric and value "0"
      
  @expired_license
  Scenario: Try to edit an existing system that got disabled due to expired license should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 02		|
		| systemLabel					| System 02 |
		| minReadCycles					| 569		|
		| noreadThreshold				| 22		|		
		| movingAverageLength			| 8			|
		| movingAverageWarningThreshold | 5.4		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/02"
      And the response status should be "412"
    Then the JSON response should have "systemList" of type array with 1 entries
      And the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The system name 02 is not permitted by the license, please check info by visiting \"/license/info\"" 
      
  @expired_license
  Scenario: Try to edit an existing system from first two systems with expired license should return response code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 02		|
		| systemLabel					| System 02 |
		| minReadCycles					| 569		|
		| noreadThreshold				| 22		|		
		| movingAverageLength			| 8			|
		| movingAverageWarningThreshold | 5.4		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/02"
      And the response status should be "200"
    Then the JSON response should have "systemList" of type array with 0 entries
      And the JSON response should have "totalSystemNumber" of type numeric and value "0"
      And the JSON response should have "numberOfSystemAllowed" of type numeric and value "2"

  Scenario: Try to delete a system with invalid request containing system name with bad parameters should return response code 412
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/0<>&4"
      And the response status should be "412"
    Then the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The system name 0<>&4 is not valid"        

  Scenario: Try to delete a non-existing system exist should return response code 404
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/044"
      And the response status should be "404"
    Then the JSON response should have "error" of type string that matches "Not Found"
      And the JSON response should have "message" of type string that matches "The system name 044 cannot be found in database"   

  Scenario: Try to delete an existing system with valid request & verify system is deleted with response code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/04"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system"
    Then the JSON response should have "$.systemList" of type array with 0 entries
      And the JSON response should have "$.totalSystemNumber" of type numeric and value "0"

# Get a list of all configured systems user systems drop-down list

  Scenario: Get list of all configured systems with success code 200
    Given I add a new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 03		|
		| systemLabel					| System 03 |
		| minReadCycles					| 990		|
		| noreadThreshold				| 12		|		
		| movingAverageLength			| 4			|
		| movingAverageWarningThreshold | 1.9		| 
      And I add another new system with following configuration:
		| facilityId					| 01		|
		| systemName					| 04		|
		| systemLabel					| System 04 |
		| minReadCycles					| 1000		|
		| noreadThreshold				| 4			|		
		| movingAverageLength			| 7			|
		| movingAverageWarningThreshold | 2.8		|
    When I send a GET request to "http://10.102.11.228:8080/system/systemList"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 2 entries


# Negative scenarios i.e. trying methods that are not allowed with certain url for "config/system" service

  Scenario: Try to call POST with incorrect url should return response code 405
    When I send a POST request to "http://10.102.11.228:8080/config/system/01"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'POST' not supported" 

  Scenario: Try to call PUT with incorrect url should return response code 405
    When I send a PUT request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'PUT' not supported" 
  
  Scenario: Try to call DELETE with incorrect url should return response code 405
    When I send a DELETE request to "http://10.102.11.228:8080/config/system"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'DELETE' not supported"

  @teardown
  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser