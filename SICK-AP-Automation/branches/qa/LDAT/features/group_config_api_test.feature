Feature: Testing IL Core device group configuration RESTful API's methods

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
      And I add a new device with following configuration:
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


# View Group scenarios i.e. GET method scenarios for "config/system/01/devicegroup" service

  Scenario Outline: Get list of all configured groups and validate configuration values after adding two groups with success code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I add another new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG02     	   					|
		| groupNoReadLimit 	| 55	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:95.5,CLVStat:92.7	|
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
      And the response status should be "200"
    Then the JSON response should have "$." of type array with 2 entries
      And the JSON response should have "<key>" of type <data_type> and value "<value>"
		Examples:
		| key								| data_type | value		|
		| $[0].name							| string    | DG02		|
		| $[0].noreadThreshold				| numeric   | 55 		|
		| $[0].statistics[0].name			| string    | CLVStat	|
		| $[0].statistics[0].threshold		| numeric   | 92.7		|
		| $[0].statistics[0].condition.name	| string    | CLV		|
		| $[0].statistics[0].condition.level| string    | BLC		|
		| $[0].statistics[1].name			| string    | CameraStat|
		| $[0].statistics[1].threshold		| numeric   | 95.5		|
		| $[0].statistics[1].condition.name	| string    | Camera	|
		| $[0].statistics[1].condition.level| string    | BLC		|
		| $[0].devices[0].deviceId			| numeric   | 1			|
		| $[0].devices[0].deviceName		| string    | MSC800	|
		| $[0].devices[1].deviceId			| numeric   | 2			|
		| $[0].devices[1].deviceName		| string    | Lector	|
		| $[1].name							| string    | DG01		|
		| $[1].noreadThreshold				| numeric   | 30 		|
		| $[1].statistics[0].name			| string    | CLVStat	|
		| $[1].statistics[0].threshold		| numeric   | 94.9		|
		| $[1].statistics[0].condition.name	| string    | CLV		|
		| $[1].statistics[0].condition.level| string    | BLC		|
		| $[1].statistics[1].name			| string    | CameraStat|
		| $[1].statistics[1].threshold		| numeric   | 92.4		|
		| $[1].statistics[1].condition.name	| string    | Camera	|
		| $[1].statistics[1].condition.level| string    | BLC		|
		| $[1].devices[0].deviceId			| numeric   | 1			|
		| $[1].devices[0].deviceName		| string    | MSC800	|
		| $[1].devices[1].deviceId			| numeric   | 2			|
		| $[1].devices[1].deviceName		| string    | Lector	|


# Add Group scenarios i.e. POST method scenarios for "config/system01/devicegroup" service

  Scenario: Try to add a new group with bad/empty request should return response code 400
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "400"

  Scenario: Try to add a new group with invalid request containing bad parameters should return response code 412
    Given I set JSON request body to:
	   """
		{
		"name": "DG<&>01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group DG<&>01 does not have valid chars in name or the length is not valid"

  Scenario: Try to add a new group with invalid request missing mandatory parameter - group name should return response code 412
    Given I set JSON request body to:
	   """
		{
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "the device group name must be populated"

   Scenario: Try to add a new group with invalid request missing mandatory parameter - devices should return response code 412
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group with the name DG01 does not contain any devices" 

  Scenario: Try to add a new group with invalid request containing bad parameters in noreadThreshold field should return response code 412
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 1001,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The no read threshold value 1001 is not valid for the Device Group DG01"

  Scenario: Try to add a new group with invalid request containing bad parameters in assigned statistics should return response code 412
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 100,
		"statistics": [
		  {
			"name": "CameraStat1",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistic CameraStat1 under the device group is not configured in this system"

  Scenario: Try to add a new group with invalid request containing bad parameters in assigned devices should return response code 412
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 100,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 11,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "the device MSC800 with the device id 11 under the group does not exist in system config"

  Scenario: Try to add a new group with invalid request containing non-unique value for a mandatory parameter group name that requires unique value should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group DG01 already exists in the system 01"

  Scenario: Try to add a new group with invalid request containing leading/trailing spaces should return response code 412
    Given I set JSON request body to:
	   """
		{
		"name": " DG01 ",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group Name must not contain leading/trailing spaces."

  Scenario: Try to add a new group with valid request missing optional parameter - noreadThreshold, statistics should return response code 201
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "201"
    
  Scenario: Try to add a new group with valid request with all mandatory & optional paramters should return response code 201
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat",
			"threshold": 95.6,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat2",
			"threshold": 98.7,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  }		  
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "201"


# Edit Group scenarios i.e. PUT method scenarios for "config/system" service

  Scenario: Try to edit an existing group with bad/empty request should return response code 400
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "400"

  Scenario: Try to edit an existing group with invalid request containing group name with bad parameters should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat",
			"threshold": 95.6,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat2",
			"threshold": 98.7,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  }		  
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """		
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG0<>&1"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group DG0<>&1 does not have valid chars in name or the length is not valid"
    
  Scenario: Try to edit an existing group with invalid request containing bad parameters should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG<&>01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group DG<&>01 does not have valid chars in name or the length is not valid"

  Scenario: Try to edit an existing group with invalid request missing mandatory parameter - group name should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "the device group name must be populated"

   Scenario: Try to edit an existing group with invalid request missing mandatory parameter - devices should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group with the name DG01 does not contain any devices" 

  Scenario: Try to edit an existing group with invalid request containing bad parameters in noreadThreshold field should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 1001,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The no read threshold value 1001 is not valid for the Device Group DG01"

  Scenario: Try to edit an existing group with invalid request containing bad parameters in assigned statistics should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 100,
		"statistics": [
		  {
			"name": "CameraStat1",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The statistic CameraStat1 under the device group is not configured in this system"

  Scenario: Try to edit an existing group with invalid request containing bad parameters in assigned devices should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 100,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 11,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "the device MSC800 with the device id 11 under the group does not exist in system config"

  Scenario: Try to edit an existing group with invalid request containing non-unique value for a mandatory parameter group name that requires unique value should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I add another new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG02     	   					|
		| groupNoReadLimit 	| 55	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:95.5,CLVStat:92.7	|
    When I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 30,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 92.4,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  }
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		  },
		  {
			"deviceId": 2,
			"deviceName": "Lector",
			"deviceType": "LECTOR",
			"noreadThreshold": 27,
			"deviceGroupNames": [
			  "DG01"
			],
			"statistics": []
		  }
		]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG02"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group DG01 already exist in the system 01"

  Scenario: Try to edit an existing group with invalid request containing leading/trailing spaces should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": " DG01 ",
		"noreadThreshold": 60,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 96.7,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat2",
			"threshold": 93.8,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  }		  
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group Name must not contain leading/trailing spaces."

  Scenario: Try to edit a non-existing group should return response code 404
    Given I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 60,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 96.7,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat2",
			"threshold": 93.8,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  }		  
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		]
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG011"
    Then the response status should be "404"
      And the JSON response should have "status" of type string that matches "NOT_FOUND"
      And the JSON response should have "message" of type string that matches "Device Group DG011 does not exist in the system 01"

  Scenario: Try to edit an existing group with valid request missing optional parameter - noreadThreshold, statistics should return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG01",
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "200"

  Scenario: Try to edit an existing group with valid request & license should return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
      And I set JSON request body to:
	   """
		{
		"name": "DG01",
		"noreadThreshold": 60,
		"statistics": [
		  {
			"name": "CameraStat",
			"threshold": 96.7,
			"condition": {
			  "name": "Camera",
			  "level": "BLC"
			}
		  },
		  {
			"name": "CLVStat2",
			"threshold": 93.8,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  }		  
		],
		"devices": [
		  {
			"deviceId": 1,
			"deviceName": "MSC800",
			"deviceType": "MSC/SIM",
			"noreadThreshold": 50,
			"deviceGroupNames": [
			  "DG01"
			],
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
		]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "200"


# Delete Group scenarios i.e. DELETE method scenarios for "config/system/01/devicegroup" service

  Scenario: Try to delete a group with invalid request containing group name with bad parameters should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG0<>&1"
      And the response status should be "412"
    Then the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Device Group DG0<>&1 does not have valid chars in name or the length is not valid"        

  Scenario: Try to delete an existing group that doesn't exist should return response code 404
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG044"
      And the response status should be "404"
    Then the JSON response should have "status" of type string that matches "NOT_FOUND"
      And the JSON response should have "message" of type string that matches "Device Group DG044 does not exist in the system 01"   

  Scenario: Try to delete an existing group with valid request & verify group is deleted with response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$." of type array with 0 entries


# Updating/Deleting a device affecting device Group scenarios

  Scenario: Verify that deleting one of the devices that is part of device group should remove that device from the group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/device/2"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "200"
      And the JSON response should have "$[0].devices" of type array with 1 entries

  Scenario: Verify that deleting one & only device from device group should delete the group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800			 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/device/1"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "200"
      And the JSON response should have "$." of type array with 0 entries

  Scenario: Verify that updating any of the devices that is part of device group should reflect the device updates in the group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    And I set JSON request body to:
	   """
		{
		"deviceId": 3,
		"deviceName": "ICR",
		"deviceType": "ICR",
		"noreadThreshold": 33,
		"deviceGroupNames": [
		  "DG01"
		],
		"statistics": [
		  {
			"name": "CLVStat",
			"threshold": 93.9,
			"condition": {
			  "name": "CLV",
			  "level": "BLC"
			}
		  }
		]
		}
	   """
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/device/2"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$[0].devices" of type array with 2 entries
      And the JSON response should have "$[0].devices[1].deviceId" of type numeric and value "3"
      And the JSON response should have "$[0].devices[1].deviceName" of type string and value "ICR"
      And the JSON response should have "$[0].devices[1].deviceType" of type string and value "ICR"
      And the JSON response should have "$[0].devices[1].noreadThreshold" of type numeric and value "33"


# Updating a condition from BLC to OLC / Deleting BLC condition affecting device Group scenarios

  Scenario: Verify that updating any BLC condition to OLC should remove the associated statistic from device group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I set JSON request body to:
	   """
		{
			"name": "Camera",
			"level": "OLC"
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$[0].statistics" of type array with 1 entries

  Scenario: Verify that deleting a BLC condition remove it's associated statistic from device group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/condition/Camera"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$[0].statistics" of type array with 1 entries


# Updating/Deleting an assigned statistic affecting device Group scenarios

  Scenario: Verify that updating an assigned statistic reflects the updates in device group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I set JSON request body to:
	   """
		{
			"name": "CameraStat1",
			"condition": {
				"name": "Camera",
				"level": "BLC"
			},
			"threshold": 94.5,
			"statLevel": {
				"label": "match code",
				"level": "MATCHCODE"
			}
		}
	   """
      And I send a PUT request to "http://10.102.11.228:8080/config/system/01/statistic/CameraStat"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$[0].statistics" of type array with 2 entries
      And the JSON response should have "$[0].statistics[1].name" of type string and value "CameraStat1"
      And the JSON response should have "$[0].statistics[1].threshold" of type numeric and value "92.4"
      And the JSON response should have "$[0].statistics[1].condition.name" of type string and value "Camera"
      And the JSON response should have "$[0].statistics[1].condition.level" of type string and value "BLC"

  Scenario: Verify that deleting an assigned statistic removes that statistic from device group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|     
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/statistic/CameraStat"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$[0].statistics" of type array with 1 entries


# Adding a new/existing device to an existing device Group(s) scenarios

#######################


# MISSED BY DEV TEAM
# NOT DONE YET


#######################


# Removing an existing device from an existing device Group scenarios

  Scenario: Try to remove a device from a group with invalid request containing device id with invalid characters should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01/device/<1>"
      And the response status should be "412"
    Then the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The device id <1> is not numeric"        

  Scenario: Try to remove a device from a group with invalid request containing device id with leading zero should return response code 412
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01/device/01"
      And the response status should be "412"
    Then the JSON response should have "error" of type string that matches "Precondition Failed"
      And the JSON response should have "message" of type string that matches "The device id 01 is not valid as it is padded with leading 0's."

  Scenario: Try to remove a non-existing device from group should return response code 404
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01/device/11"
      And the response status should be "404"
    Then the JSON response should have "status" of type string that matches "NOT_FOUND"
      And the JSON response should have "message" of type string that matches "Device 11 does not exist in the  Device Group DG01"   

  Scenario: Try to remove a device from a group with valid request & verify device is removed with response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800,2:Lector 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01/device/2"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the JSON response should have "$[0].devices" of type array with 1 entries

  Scenario: Verify that removing one & only device from device group should delete the group with return response code 200
    Given I add a new group with following configuration:
		| facilityId	 	| 01		   					|
		| systemName	 	| 01		   					|
		| groupName	 	    | DG01     	   					|
		| groupNoReadLimit 	| 30	   	   					|
		| assignedDevices	| 1:MSC800			 			|
		| assignedStatistics| Camera:CameraStat,CLV:CLVStat |
		| groupExpReadRate  | CameraStat:92.4,CLVStat:94.9	|
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01/device/1"
      And the response status should be "200"
      And I clear the response cache
      And I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "200"
      And the JSON response should have "$." of type array with 0 entries


# Negative scenarios i.e. trying methods that are not allowed with certain url for "config/system" service

  Scenario: Try to call GET with incorrect url should return response code 405
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'GET' not supported" 

  Scenario: Try to call GET with incorrect url should return response code 405
    When I send a GET request to "http://10.102.11.228:8080/config/system/01/devicegroup/1"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'GET' not supported"

  Scenario: Try to call POST with incorrect url should return response code 405
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup/DG01"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'POST' not supported" 

  Scenario: Try to call POST with incorrect url should return response code 405
    When I send a POST request to "http://10.102.11.228:8080/config/system/01/devicegroup/1"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'POST' not supported"

  Scenario: Try to call PUT with incorrect url should return response code 405
    When I send a PUT request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'PUT' not supported" 

  Scenario: Try to call DELETE with incorrect url should return response code 405
    When I send a DELETE request to "http://10.102.11.228:8080/config/system/01/devicegroup"
    Then the response status should be "405"
      And the JSON response should have "status" of type string that matches "METHOD_NOT_ALLOWED"
      And the JSON response should have "message" of type string that matches "Request method 'DELETE' not supported"

  @teardown
  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser