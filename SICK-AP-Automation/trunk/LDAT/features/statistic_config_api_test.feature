Feature: Testing IL Core statistic configuration RESTful API's methods
# pending - adding scenarios for disabled statistics in drop-down and statistic configuration page

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
      And I add multiple new condition with following configuration:
		| facilityId	 | 01		 |   
		| systemName	 | 01		 |
		| conditionNameAndLevel	 | OLC:ValidRead,OLC:ValidWeight,OLC:T1T2,BLC:Camera,BLC:CLV |


# View Statistic scenarios i.e. GET method scenarios for "config/system/01/statistic" service

  Scenario: Get list of all configured statistics after adding multiple statistics with success code 200
    Given I add multiple new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionNameAndLevel	 | OLC:ValidRead,OLC:ValidWeight,OLC:T1T2,BLC:Camera,BLC:CLV |
		| statisticNameAndCondition | ValidReadStat:ValidRead,ValidWeightStat:ValidWeight,GeneralStat:T1T2,CameraStat:Camera,CLVStat:CLV,CLVStat2:CLV |
		| statisticNameAndsystemExpReadRate | ValidReadStat:95.6,ValidWeightStat:92.3,GeneralStat:89.2,CameraStat:93.9,CLVStat:78.1,CLVStat2:99.2 |	
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 6 entries
      And I clear the response cache

  Scenario Outline: Verify that newly configured statistic's values match with values passed while creating it with success code 200
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 1 entries
      And the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key		 		   | data_type | value	 	   |
		| $[0].name	 		   | string    | ValidReadStat |
		| $[0].threshold	   | numeric   | 95.6		   |
		| $[0].condition.name  | string    | ValidRead	   |
		| $[0].condition.level | string    | OLC 		   |
		| $[0].statLevel.level | string    | PRIMARY	   |


# Add Statistic scenarios i.e. POST method scenarios for "config/system/01/statistic" service

  Scenario: Try to add a new statistic with bad/empty request should return response code 400
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "400"

  Scenario: Try to add a new statistic with invalid request containing bad parameters should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "ValidRead<&>Stat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"

  Scenario: Try to add a new statistic with invalid request missing mandatory parameter - statistic name should return response code 412
    Given I set JSON request body to:
	   """
		{
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"

  Scenario: Try to add a new statistic with invalid request missing mandatory parameter - condition name should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."
      
  Scenario: Try to add a new statistic with invalid request missing mandatory parameter - condition level should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to add a new statistic with invalid request missing mandatory parameter - stat level should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to add a new statistic with invalid request containing bad parameters in statistic level field should return response code 400
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "other",
				"level": "OTHER"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "400"

  Scenario: Try to add a new statistic with invalid request containing bad parameters in condition's level field should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to add a new statistic with invalid request missing optional parameter - threshold should return response code 201
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "201"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the response status should be "200"     
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to add a new statistic with invalid request containing non-unique value for a mandatory parameter statistic name that requires unique value should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Statistic already exists in the system"

  Scenario: Try to add a new statistic with invalid request containing leading/trailing spaces should return response code 412
    Given I set JSON request body to:
	   """
		{
			"name": " ValidReadStat ",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"

  Scenario: Try to add a new statistic with valid request should return response code 201
    Given I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "201"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to add a second primary statistic when one is already present should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	  |
		| systemName	 	   | 01		 	  |   
		| conditionName	 	   | ValidRead 	  |
		| conditionLevel 	   | OLC		  |
		| statisticName		   | PrimaryStat1 |
		| statisticType		   | primary	  |
		| systemExpReadRate    | 95.6	 	  |
    When I set JSON request body to:
	   """
		{
			"name": "PrimaryStat2",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "primary",
				"level": "PRIMARY"
			}
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid input parameter. Invalid/Inconsistant statistics condition"

  Scenario: Try to add a second secondary statistic when one is already present should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	    |
		| systemName	 	   | 01		 	    |   
		| conditionName	 	   | ValidWeight    |
		| conditionLevel 	   | OLC		    |
		| statisticName		   | SecondaryStat1 |
		| statisticType		   | secondary	    |
		| systemExpReadRate    | 95.6	 	    |
    When I set JSON request body to:
	   """
		{
			"name": "SecondaryStat2",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "secondary",
				"level": "SECONDARY"
			}
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid input parameter. Invalid/Inconsistant statistics condition"

  Scenario: Try to add a second match code statistic based on a BLC condition for which one statistic is already present should return response code 201
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	|
		| systemName	 	   | 01		 	|   
		| conditionName	 	   | Camera     |
		| conditionLevel 	   | BLC		|
		| statisticName		   | CameraStat |
		| statisticType		   | assigned	|
		| systemExpReadRate    | 95.6	 	|
    When I set JSON request body to:
	   """
		{
			"name": "CameraStat2",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "match code",
				"level": "MATCHCODE"
			}
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "201"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the JSON response should have "$." of type array with 2 entries

  Scenario: Try to add a second statistic based on a OLC condition for which one statistic is already present should return response code 201
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat2",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "201"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the JSON response should have "$." of type array with 2 entries


 # Edit Statistic scenarios i.e. PUT method scenarios for "config/system/01/statistic" service

  Scenario: Try to edit an existing statistic with bad/empty request should return response code 400
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/Camera"
    Then the response status should be "400"

  Scenario: Try to edit an existing statistic with invalid request containing bad parameters should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidRead<&>Stat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"

  Scenario: Try to edit an existing statistic with invalid request missing mandatory parameter - statistic name should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"

  Scenario: Try to edit an existing statistic with invalid request missing mandatory parameter - condition name should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing statistic with invalid request missing mandatory parameter - condition level should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing statistic with invalid request missing mandatory parameter - stat level should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing statistic with invalid request missing optional parameter - threshold should return response code 200
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "200"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the response status should be "200"     
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to edit an existing statistic with invalid request containing bad parameters in statistic level field should return response code 400
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "other",
				"level": "OTHER"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "400"

  Scenario: Try to edit an existing statistic with invalid request containing bad parameters in condition's level field should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing statistic with invalid request containing non-unique value for a mandatory parameter statistic name that requires unique value should return response code 412
    Given I add multiple new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionNameAndLevel	 | OLC:ValidRead,OLC:ValidWeight,OLC:T1T2,BLC:Camera,BLC:CLV |
		| statisticNameAndCondition | ValidReadStat:ValidRead,ValidWeightStat:ValidWeight,GeneralStat:T1T2,CameraStat:Camera,CLVStat:CLV,CLVStat2:CLV |
		| statisticNameAndsystemExpReadRate | ValidReadStat:95.6,ValidWeightStat:92.3,GeneralStat:89.2,CameraStat:93.9,CLVStat:78.1,CLVStat2:99.2 |
    When I set JSON request body to:
	   """
		{
			"name": "ValidWeightStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Statistic already exists in the system"

  Scenario: Try to edit an existing statistic with invalid request containing leading/trailing spaces should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": " ValidWeightStat ",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"

  Scenario: Try to edit an existing statistic with valid request should return response code 200
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to edit an existing statistic to make it primary when one primary is already present should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	  |
		| systemName	 	   | 01		 	  |   
		| conditionName	 	   | ValidRead 	  |
		| conditionLevel 	   | OLC		  |
		| statisticName		   | PrimaryStat1 |
		| statisticType		   | primary	  |
		| systemExpReadRate    | 95.6	 	  |
	  And I add multiple new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionNameAndLevel	 | OLC:ValidRead,OLC:ValidWeight,OLC:T1T2,BLC:Camera,BLC:CLV |
		| statisticNameAndCondition | ValidReadStat:ValidRead,ValidWeightStat:ValidWeight,GeneralStat:T1T2,CameraStat:Camera,CLVStat:CLV,CLVStat2:CLV |
		| statisticNameAndsystemExpReadRate | ValidReadStat:95.6,ValidWeightStat:92.3,GeneralStat:89.2,CameraStat:93.9,CLVStat:78.1,CLVStat2:99.2 |
    When I set JSON request body to:
	   """
		{
			"name": "PrimaryStat2",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "primary",
				"level": "PRIMARY"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Trying to update statistic to be the primary statistic but it is already configured"

  Scenario: Try to edit an existing statistic to make it secondary when one secondary is already present should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	    |
		| systemName	 	   | 01		 	    |   
		| conditionName	 	   | ValidWeight    |
		| conditionLevel 	   | OLC		    |
		| statisticName		   | SecondaryStat1 |
		| statisticType		   | secondary	    |
		| systemExpReadRate    | 95.6	 	    |
	  And I add multiple new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionNameAndLevel	 | OLC:ValidRead,OLC:ValidWeight,OLC:T1T2,BLC:Camera,BLC:CLV |
		| statisticNameAndCondition | ValidReadStat:ValidRead,ValidWeightStat:ValidWeight,GeneralStat:T1T2,CameraStat:Camera,CLVStat:CLV,CLVStat2:CLV |
		| statisticNameAndsystemExpReadRate | ValidReadStat:95.6,ValidWeightStat:92.3,GeneralStat:89.2,CameraStat:93.9,CLVStat:78.1,CLVStat2:99.2 |
    When I set JSON request body to:
	   """
		{
			"name": "SecondaryStat2",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "secondary",
				"level": "SECONDARY"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidWeightStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Trying to update statistic to be the secondary statistic but it is already configured"

  Scenario: Try to edit an existing primary statistic's associated condition to a BLC condition should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	  |
		| systemName	 	   | 01		 	  |   
		| conditionName	 	   | ValidRead 	  |
		| conditionLevel 	   | OLC		  |
		| statisticName		   | PrimaryStat1 |
		| statisticType		   | primary	  |
		| systemExpReadRate    | 95.6	 	  |
    When I set JSON request body to:
	   """
		{
			"name": "PrimaryStat1",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "primary",
				"level": "PRIMARY"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/PrimaryStat1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing secondary statistic's associated condition to a BLC condition should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	    |
		| systemName	 	   | 01		 	    |   
		| conditionName	 	   | ValidWeight    |
		| conditionLevel 	   | OLC		    |
		| statisticName		   | SecondaryStat1 |
		| statisticType		   | secondary	    |
		| systemExpReadRate    | 95.6	 	    |
    When I set JSON request body to:
	   """
		{
			"name": "SecondaryStat2",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "secondary",
				"level": "SECONDARY"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/SecondaryStat1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing match code statistic to make it primary statistic should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | Camera    	   |
		| conditionLevel 	   | BLC		   |
		| statisticName		   | MatchCodeStat |
		| statisticType		   | assigned	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "MatchCodeStat",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "primary",
				"level": "PRIMARY"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/MatchCodeStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing match code statistic to make it secondary statistic should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | Camera    	   |
		| conditionLevel 	   | BLC		   |
		| statisticName		   | MatchCodeStat |
		| statisticType		   | assigned	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "MatchCodeStat",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "secondary",
				"level": "SECONDARY"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/MatchCodeStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing match code statistic to make it object level statistic should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | Camera    	   |
		| conditionLevel 	   | BLC		   |
		| statisticName		   | MatchCodeStat |
		| statisticType		   | assigned	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "MatchCodeStat",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/MatchCodeStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Input StatisticDTO."

  Scenario: Try to edit an existing match code statistic's associated condition to an OLC condition and make it object level statistic should return response code 200
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | Camera    	   |
		| conditionLevel 	   | BLC		   |
		| statisticName		   | MatchCodeStat |
		| statisticType		   | assigned	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "ValidReadStat",
			"condition": {
				"name": "ValidRead",
				"level": "OLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "none",
				"level": "NONE"
			}
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/MatchCodeStat"
    Then the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to edit an existing statistic's associated condition to a BLC condition to make it match code statistic should return response code 200
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | assigned	   |
		| systemExpReadRate    | 95.6	 	   |
    When I set JSON request body to:
	   """
		{
			"name": "MatchCodeStat",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 99.7,
			"statLevel": {
				"label": "match code",
				"level": "MATCHCODE"
			}
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
      And the JSON response should have "$." of type array with 1 entries


 # Delete Statistic scenarios i.e. DELETE method scenarios for "config/system/01/statistic" service  

  Scenario: Try to delete a non-existing statistic should return response code 404
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/statistic/CameraStat"
    Then the response status should be "404"

  Scenario: Try to delete a statistic with invalid request containing statistic name with bad parameters should return response code 412
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   | 
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/statistic/Valid<&>ReadStat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Invalid Statistics Name"
 
  Scenario: Try to delete an existing statistic with valid request & verify statistic is deleted with response code 200    
    Given I add a new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionName	 	   | ValidRead 	   |
		| conditionLevel 	   | OLC		   |
		| statisticName		   | ValidReadStat |
		| statisticType		   | primary	   |
		| systemExpReadRate    | 95.6	 	   |  
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/statistic/ValidReadStat"
    Then the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the JSON response should have "$." of type array with 0 entries


# Negative scenarios i.e. trying methods that are not allowed with certain url for "config/system/01/statistic" service

  Scenario: Try to call GET with incorrect url should return response code 405
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/statistic/CameraStat"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'GET' not supported" 

  Scenario: Try to call POST with incorrect url should return response code 405
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/statistic/CameraStat"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'POST' not supported" 

  Scenario: Try to call PUT with incorrect url should return response code 405
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'PUT' not supported" 

  Scenario: Try to call DELETE with incorrect url should return response code 405
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/statistic"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'DELETE' not supported"		

  @teardown
  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser