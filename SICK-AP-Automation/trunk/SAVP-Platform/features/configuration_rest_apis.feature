Feature: RESTful API testing feature

# Get a list of all devices scenario

  Scenario: Get list of all configured devices with success code 200
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the response status should be "200"
    And show me the unparsed response

# Adding a new device scenarios
   
  Scenario: Add a new device failure due to invalid request (empty JSON) with response code 400
	Given I send and accept JSON
	When I send a POST request to "/device" with the following:
	   """
		{
		}
	   """
    Then the response status should be "400"
    
  Scenario: Add a new device failure due to invalid request (missing required field - deviceId) with response code 400
	Given I send and accept JSON
	When I send a POST request to "/device" with the following:
	   """
		{
			"name": "TEST",
			"family": "LECTOR 65x",
			"label": "TEST API",
			"ftpInformation": {
				"username": "test",
				"password": "password"
			},
			"ipAddress": "192.168.0.1"
		}
	   """
    Then the response status should be "400"
    
  Scenario: Add a new device successfully by making a valid request with response code 201
    Given I send and accept JSON
	When I send a POST request to "/device" with the following:
	   """
		{
			"deviceId": 1,
			"name": "TEST",
			"family": "LECTOR 65x",
			"label": "TEST API",
			"ftpInformation": {
				"username": "test",
				"password": "password"
			},
			"ipAddress": "192.168.0.1"
		}
	   """
    Then the response status should be "201"
    
  Scenario Outline: Validate whether the newly added device has correct information in each field
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "<key>" with the text "<value>"
	Examples:
	| key           | value        |
	| $..deviceId   | 1            |
	| $..type       | device       |
	| $..facilityId | 01           |
	| $..systemId   | 01           |
	| $..name       | TEST         |
	| $..family     | LECTOR 65x   |
	| $..label      | TEST API     |
	| $..ipAddress  | 192.168.0.1  |
	| $..username   | test  	   |
	| $..password   | password	   |
	 
   Scenario: Add a new device failure due to invalid request (duplicate required field - deviceId) with response code 400
	Given I send and accept JSON
	When I send a POST request to "/device" with the following:
	   """
		{
			"deviceId": 1,
			"name": "TEST2",
			"family": "ICR890",
			"label": "TEST API DUP",
			"ftpInformation": {
				"username": "test",
				"password": "password"
			},
			"ipAddress": "192.168.0.2"
		}
	   """
    Then the response status should be "400"
    And show me the unparsed response

   Scenario: Add a new device failure due to invalid request (duplicate required field - name) with response code 400
	Given I send and accept JSON
	When I send a POST request to "/device" with the following:
	   """
		{
			"deviceId": 2,
			"name": "TEST",
			"family": "ICR890",
			"label": "TEST API DUP",
			"ftpInformation": {
				"username": "test",
				"password": "password"
			},
			"ipAddress": "192.168.0.2"
		}
	   """
    Then the response status should be "400"
    And show me the unparsed response
    
# Updating an existing device scenarios 
  @pending
  Scenario: Update a device successfully with response code 200
    Given I send and accept JSON
	When I send a PUT request to "/device/undefined" with the following:
	   """
		{
			"deviceId": 1,
			"type": "device",
			"facilityId": "01",
			"systemId": "01",
			"name": "TEST",
			"family": "LECTOR 65x",
			"label": "TEST API",
			"ipAddress": "192.168.0.1",
			"ftpInformation": {
				"password": "password",
				"username": "test1"
			},
			"_id": "01_01_001",
			"_rev": "2-f36d0806b3696ad305227fcca5e03b2e"
		}
	   """
    Then the response status should be "200"
    
  @pending
  Scenario: Update a device failure due to invalid request (duplicate required field - deviceId) with response code 400
    Given I send and accept JSON
	When I send a PUT request to "/device" with the following:
	   """
		{
			"deviceId": 1,
			"type": "device",
			"facilityId": "01",
			"systemId": "01",
			"name": "TEST",
			"family": "LECTOR 65x",
			"label": "TEST API",
			"ipAddress": "192.168.0.1",
			"ftpInformation": {
				"password": "password",
				"username": "test1"
			},
			"_id": "01_01_001",
			"_rev": "2-f36d0806b3696ad305227fcca5e03b2e"
		}
	   """
    Then the response status should be "200"
    
  @pending
  Scenario: Update a device failure due to invalid request (duplicate required field - name) with response code 400
    Given I send and accept JSON
	When I send a PUT request to "/device" with the following:
	   """
		{
			"deviceId": 1,
			"type": "device",
			"facilityId": "01",
			"systemId": "01",
			"name": "TEST",
			"family": "LECTOR 65x",
			"label": "TEST API",
			"ipAddress": "192.168.0.1",
			"ftpInformation": {
				"password": "password",
				"username": "test1"
			},
			"_id": "01_01_001",
			"_rev": "2-f36d0806b3696ad305227fcca5e03b2e"
		}
	   """
    Then the response status should be "200"
    
  @pending
  Scenario: Update a device failure due to device not found with response code 404
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "$..deviceId" with the text "1"
  @pending    
  Scenario: Update a device failure due to edit conflict with response code 409
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "$..deviceId" with the text "1"
  @pending    
  Scenario: Update a device failure due to internal server error with response code 500
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "$..deviceId" with the text "1"

    
# delete device scenarios 
 @pending
  Scenario: Delete a device successfully with response code 200
	Given I send a DELETE request to "/device/01_01_999" with the following:
	   """
		1-0a765fcea8bce15e375a5391a03c2448
	   """
    Then the response status should be "200"
  @pending    
  Scenario: Delete a device failure due to device not found with response code 404
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "$..deviceId" with the text "1"
  @pending           
  Scenario: Delete a device failure due to edit conflict with response code 409
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "$..deviceId" with the text "1"
  @pending    		  
  Scenario: Delete a device failure due to internal server error with response code 500
    Given I send and accept JSON
	When I send a GET request to "/device"
    Then the JSON response should have "$..deviceId" with the text "1"
    		  
  Scenario: Print test configuration & close the browser
	Then I print configuration
	Then I close browser