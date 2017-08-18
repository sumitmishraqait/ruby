Feature: Testing IL Core device configuration RESTful API's methods
# pending - adding scenarios for disabled devices in drop-down and device configuration page

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
      And I add multiple new statistic with following configuration:
		| facilityId	 	   | 01		 	   |
		| systemName	 	   | 01		 	   |   
		| conditionNameAndLevel	 | OLC:ValidRead,OLC:ValidWeight,OLC:T1T2,BLC:Camera,BLC:CLV |
		| statisticNameAndCondition | ValidReadStat:ValidRead,ValidWeightStat:ValidWeight,GeneralStat:T1T2,CameraStat:Camera,CLVStat:CLV,CLVStat2:CLV |
		| statisticNameAndsystemExpReadRate | ValidReadStat:95.6,ValidWeightStat:92.3,GeneralStat:89.2,CameraStat:93.9,CLVStat:78.1,CLVStat2:99.2 |


# View Device scenarios i.e. GET method scenarios for "config/system/01/device" service

  Scenario: Get list of all configured devices after adding two devices with success code 200
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceUsername	| msc		   |
		| devicePassword	| sick	 	   |
		| deviceIp	   		| 192.168.0.32 |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
      And I add another new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |   
		| deviceId	 	    | 2     	   |
		| deviceName 	    | Lector	   |
		| deviceType		| LECTOR 	   |
		| deviceUsername	| lector	   |
		| devicePassword	| sick	 	   |
		| deviceIp	   		| 192.168.0.64 |
		| deviceNoReadLimit | 27	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | NULL	 	   |
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 2 entries
      And I clear the response cache

  Scenario Outline: Verify that newly configured device's values match with values passed while creating it with success code 200
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 1 entries
      And the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key		 		  	 			| data_type | value	 	|
		| $[0].deviceId		   	 			| numeric   | 1			|
		| $[0].deviceName	   	 			| string    | MSC800 		|
		| $[0].deviceType	   	 			| string    | MSC/SIM 		|
		| $[0].noreadThreshold 	 			| numeric   | 50	   		|
		| $[0].statistics[0].condition.name | string    | Camera	   	|
		| $[0].statistics[0].name 	 		| string    | CameraStat	|
		| $[0].statistics[0].threshold		| numeric   | 93.9	   		|


# Add Device scenarios i.e. POST method scenarios for "config/system/01/device" service

  Scenario: Try to add a new device with bad/empty request should return response code 400
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "400"

  Scenario: Try to add a new device with invalid request containing device id below the allowed range of 1-64 should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 0,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to add a new device with invalid request containing device id above the allowed range of 1-64 should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 65,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to add a new device with invalid request containing negative device id should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": -1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to add a new device with invalid request containing invalid device id should return response code 400
    Given I set JSON request body to:
	   """
		{
		"deviceId": "one",
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "400"

  Scenario: Try to add a new device with invalid request missing mandatory parameter - device id should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to add a new device with invalid request missing mandatory parameter - device name should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Name is not valid !"

  Scenario: Try to add a new device with invalid request missing mandatory parameter - device type should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The devcie type null is not configured in the facility!"

  Scenario: Try to add a new device with invalid request missing optional parameter - device group names should return response code 201
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "201"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the response status should be "200"     
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to add a new device with invalid request missing optional parameter - no read threshold should return response code 201
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "201"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the response status should be "200"     
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to add a new device with invalid request missing mandatory parameter - condition name should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistics under the system are not configured properly"

  Scenario: Try to add a new device with invalid request missing mandatory parameter - condition level should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistics under the system are not configured properly"

  Scenario: Try to add a new device with invalid request missing mandatory parameter - statistic name should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistics under the system are not configured properly"

  Scenario: Try to add a new device with invalid request missing optional parameter - statistic threshold should return response code 201
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "201"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the response status should be "200"     
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to add a new device with invalid request containing leading/trailing spaces in device name should return response code 412
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": " MSC800 ",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Name is not valid !"

  Scenario: Try to add a new device with invalid request containing non-unique value for a mandatory parameter device name that requires unique value should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |   
		| deviceId	 	    | 2     	   |
		| deviceName 	    | Lector	   |
		| deviceType		| LECTOR 	   |
		| deviceNoReadLimit | 27	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | NULL	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 2,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "the device with id 2 is already configured!"

  Scenario: Try to add a new device with valid request should return response code 201
    Given I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "201"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the JSON response should have "$." of type array with 1 entries


# Edit Device scenarios i.e. PUT method scenarios for "config/system/01/device" service

  Scenario: Try to edit an existing device with bad/empty request should return response code 400
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "400"

  Scenario: Try to edit an existing device with invalid request containing device id below the allowed range of 1-64 should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 0,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to edit an existing device with invalid request containing device id above the allowed range of 1-64 should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 65,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to edit an existing device with invalid request containing negative device id should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": -1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to edit an existing device with invalid request containing invalid device id should return response code 400
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": "one",
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "400"

  Scenario: Try to edit an existing device with invalid request missing mandatory parameter - device id should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device id should be a number between 1 to 64"

  Scenario: Try to edit an existing device with invalid request missing mandatory parameter - device name should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Name is not valid !"

  Scenario: Try to edit an existing device with invalid request missing mandatory parameter - device type should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The devcie type null is not configured in the facility!"

  Scenario: Try to edit an existing device with invalid request missing optional parameter - device group names should return response code 200
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "200"
      And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the response status should be "200"     
      And the JSON response should have "$." of type array with 1 entries

  Scenario: Try to edit an existing device with invalid request missing optional parameter - no read threshold should return response code 200
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "200"

  Scenario: Try to edit an existing device with invalid request missing mandatory parameter - condition name should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistics under the system are not configured properly"

  Scenario: Try to edit an existing device with invalid request missing mandatory parameter - condition level should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistics under the system are not configured properly"

  Scenario: Try to edit an existing device with invalid request missing mandatory parameter - statistic name should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistics under the system are not configured properly"

  Scenario: Try to edit an existing device with invalid request missing optional parameter - statistic threshold should return response code 200
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": []
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "200"

  Scenario: Try to edit an existing device with invalid request containing leading/trailing spaces in device name should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": " MSC800 ",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Name is not valid !"

  Scenario: Try to edit an existing device with invalid request containing non-unique value for a mandatory parameter device id that requires unique value should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
      And I add another new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |   
		| deviceId	 	    | 2     	   |
		| deviceName 	    | Lector	   |
		| deviceType		| LECTOR 	   |
		| deviceNoReadLimit | 27	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | NULL	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 2,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "the device with id updated 2 already exist!"

  Scenario: Try to edit an existing device with valid request should return response code 200
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |   
		| deviceId	 	    | 2     	   |
		| deviceName 	    | Lector	   |
		| deviceType		| LECTOR 	   |
		| deviceNoReadLimit | 27	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | NULL	 	   |
    When I set JSON request body to:
	   """
		{
		"deviceId": 1,
		"deviceName": "MSC800",
		"deviceType": "MSC/SIM",
		"noreadThreshold": 50,
		"deviceGroupNames": null,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 93.9,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		 ]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/2"
    Then the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
      And the JSON response should have "$." of type array with 1 entries


 # Delete Device scenarios i.e. DELETE method scenarios for "config/system/01/device" service 

  Scenario: Try to delete a non-existing device should return response code 404
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/device/2"
    Then the response status should be "404"

  Scenario: Try to delete a device with invalid request containing device id with bad parameters should return response code 412
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   | 
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/device/1<&>"
    Then the response status should be "412"
      And the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The device id 1<&> is not numeric"

  Scenario: Try to delete an existing device with valid request & verify device is deleted with response code 200    
    Given I add a new device with following configuration:
		| facilityId	 	| 01		   |
		| systemName	 	| 01		   |
		| deviceId	 	    | 1     	   |
		| deviceName 	    | MSC800	   |
		| deviceType		| MSC/SIM 	   |
		| deviceNoReadLimit | 50	 	   |
		| conditionName	 	| Camera	   |
		| statisticName		| CameraStat   |
		| deviceExpReadRate | 93.9	 	   |
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/device"
    Then the JSON response should have "$." of type array with 0 entries
 
 
# Negative scenarios i.e. trying methods that are not allowed with certain url for "config/system/01/device" service

  Scenario: Try to call GET with incorrect url should return response code 405
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'GET' not supported" 

  Scenario: Try to call POST with incorrect url should return response code 405
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/device/1"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'POST' not supported" 

  Scenario: Try to call PUT with incorrect url should return response code 405
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'PUT' not supported" 

  Scenario: Try to call DELETE with incorrect url should return response code 405
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/device"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'DELETE' not supported"

 @teardown
  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser