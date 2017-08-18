Feature: Testing IL Core Software Settings RESTful API's methods

  Background:
	Given I am testing a REST API
	  And I send "text/plain" and accept JSON
	  And I reset software settings of following server:
	  	| table		 | facility		 |
	  	| keyspace	 | sick_il		 |
	  	| ip_address | 10.102.11.228 |

# View user settings (global) scenarios on Software Settings page i.e. GET method scenarios for "/settings" service

  Scenario: Get all the user settings options with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')].settings" of type array with 3 entries
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='dateFormat')].label" of type string and value "Date format"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].label" of type string and value "Time format"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].label" of type string and value "Unit system"

  Scenario: Get all date format options allowed under user settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='dateFormat')].acceptedValues" of type array with 1 entries
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='dateFormat')].acceptedValues.[?(@.code=='DEFAULT')].label" of type string and value "dd MMM yyyy"

  Scenario: Get default date format under user settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='dateFormat')].value.label" of type string and value "dd MMM yyyy"

  Scenario: Verify that date format field under user settings is read only with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='dateFormat')].actionsAllowed.update" of type boolean and value "false"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='dateFormat')].actionsAllowed.delete" of type boolean and value "false"

  Scenario: Get all time format options allowed under user settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].acceptedValues" of type array with 2 entries
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].acceptedValues.[?(@.code=='ISO_12_HOUR')].label" of type string and value "12-hour"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].acceptedValues.[?(@.code=='ISO_24_HOUR')].label" of type string and value "24-hour"

  Scenario: Get default time format under user settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].value.label" of type string and value "24-hour"

  Scenario: Verify that time format field under user settings is editable with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].actionsAllowed.update" of type boolean and value "true"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].actionsAllowed.delete" of type boolean and value "false"

  Scenario: Get all unit system options allowed under user settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].acceptedValues" of type array with 3 entries
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].acceptedValues.[?(@.code=='IMPERIAL_FEET')].label" of type string and value "Imperial-feet"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].acceptedValues.[?(@.code=='IMPERIAL_INCHES')].label" of type string and value "Imperial-inches"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].acceptedValues.[?(@.code=='METRIC')].label" of type string and value "Metric"

  Scenario: Get default unit system under user settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].value.label" of type string and value "Metric"

  Scenario: Verify that unit system field under user settings is editable with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].actionsAllowed.update" of type boolean and value "true"
      And the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].actionsAllowed.delete" of type boolean and value "false"


# Update user settings scenarios on Software Settings page i.e. PUT method scenarios for "/settings/userSettings/{settingCode}" service

  Scenario: Try to change date format value which is read only under user settings should return response code 412
    Given I set request body to "mm dd yyyy four hour"
    When I send a PUT request to "http://10.102.11.228:8080/settings/userSettings/dateFormat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Update operation not allowed for setting dateFormat"

  Scenario: Try to change time format value to anything else other than allowed values ISO_12_HOUR & ISO_24_HOUR under user settings should return response code 412
    Given I set request body to "twenty four hour"
    When I send a PUT request to "http://10.102.11.228:8080/settings/userSettings/timeFormat"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The new value is not an accepted value, could not update the setting"   

  Scenario: Change time format value to a valid allowed value ISO_12_HOUR under user settings with response code 200
    Given I set request body to "ISO_12_HOUR"
    When I send a PUT request to "http://10.102.11.228:8080/settings/userSettings/timeFormat"
    Then the response status should be "200"
       And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/settings"
      And the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='timeFormat')].value.label" of type string and value "12-hour"

  Scenario: Try to change unit system value to anything else other than allowed values IMPERIAL_FEET, IMPERIAL_INCHES & METRIC under user settings should return response code 412
    Given I set request body to "Imperial"
    When I send a PUT request to "http://10.102.11.228:8080/settings/userSettings/unitSystem"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "The new value is not an accepted value, could not update the setting"

  Scenario: Change unit system value to a valid allowed value IMPERIAL_INCHES under user settings with response code 200
    Given I set request body to "IMPERIAL_INCHES"
    When I send a PUT request to "http://10.102.11.228:8080/settings/userSettings/unitSystem"
    Then the response status should be "200"
       And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/settings"
      And the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='userSettings')]..[?(@.code=='unitSystem')].value.label" of type string and value "Imperial-inches"


# View database settings scenarios on Software Settings page i.e. GET method scenarios for "/settings" service

  Scenario: Get all the database settings options with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='databaseSettings')].settings" of type array with 2 entries
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].label" of type string and value "Keep data"
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='databaseUsage')].label" of type string and value "Database usage"

  Scenario: Get max & min values (in days) allowed for keep data allowed under database settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].validations" of type array with 2 entries
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].validations.[?(@.code=='max')].label" of type string and value "366"
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].validations.[?(@.code=='min')].label" of type string and value "1"

  Scenario: Get default value (in days) for keep data under database settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].value.label" of type string and value "90"

  Scenario: Verify that keep data field under database settings is editable with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].actionsAllowed.update" of type boolean and value "true"
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].actionsAllowed.delete" of type boolean and value "false"

  Scenario: Get database usage value (in GB & percentage) under database settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then I grab "$..[?(@.code=='databaseSettings')]..[?(@.code=='databaseUsage')].value.code" as "db_usage"
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='databaseUsage')].value.label" of type string and value "{db_usage}"

  Scenario: Verify that database usage field under database settings is read only with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='databaseUsage')].actionsAllowed.update" of type boolean and value "false"
      And the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='databaseUsage')].actionsAllowed.delete" of type boolean and value "false"


# Update database settings scenarios on Software Settings page i.e. PUT method scenarios for "/settings/databaseSettings/{settingCode}" service

  Scenario: Try to change keep data value (in days) with a non-integar under database settings should return response code 412
    Given I set request body to "thirty"
    When I send a PUT request to "http://10.102.11.228:8080/settings/databaseSettings/dataRetention"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Unable to parse the new value thirty into the required dataType of Integer"  

  Scenario: Try to change keep data value (in days) below the minimum allowed value i.e. 1 under database settings should return response code 412
    Given I set request body to "0"
    When I send a PUT request to "http://10.102.11.228:8080/settings/databaseSettings/dataRetention"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "New value is less that acceptable min value of 1"    

  Scenario: Try to change keep data value (in days) over the maximum allowed value i.e. 366 under database settings should return response code 412
    Given I set request body to "367"
    When I send a PUT request to "http://10.102.11.228:8080/settings/databaseSettings/dataRetention"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "New value is greater that acceptable max value of 366" 

  Scenario: Change keep data value (in days) within the allowed range i.e. 1 - 366 under database settings with response code 200
    Given I set request body to "30"
    When I send a PUT request to "http://10.102.11.228:8080/settings/databaseSettings/dataRetention"
    Then the response status should be "200"
       And I clear the response cache
    When I send a GET request to "http://10.102.11.228:8080/settings"
      And the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='databaseSettings')]..[?(@.code=='dataRetention')].value.code" of type string and value "30"

  Scenario: Try to change database usage value which is read only under database settings should return response code 412
    Given I set request body to "346.8 MB(0.86% of C:drive)"
    When I send a PUT request to "http://10.102.11.228:8080/settings/databaseSettings/databaseUsage"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Update operation not allowed for setting databaseUsage"


 # View log file settings scenarios on Software Settings page i.e. GET method scenarios for "/settings" service

  Scenario: Get all the log file settings options with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='logFileSettings')].settings" of type array with 2 entries
      And the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].label" of type string and value "Keep logs"
      And the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logFileLocation')].label" of type string and value "Logfile location"

  Scenario: Get max & min values (in days) allowed for keep logs allowed under log file settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].validations" of type array with 2 entries
      And the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].validations.[?(@.code=='max')].label" of type string and value "30"
      And the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].validations.[?(@.code=='min')].label" of type string and value "1"

  Scenario: Get default value (in days) for keep logs under log file settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].value.code" of type string and value "10"

  Scenario: Verify that keep logs field under log file settings is read only with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].actionsAllowed.update" of type boolean and value "false"
      And the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logsRetention')].actionsAllowed.delete" of type boolean and value "false"

  Scenario: Get log usage value (in GB & percentage) under log file settings with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logFileLocation')].value.label" of type string and value "C:\SICK\Analytics\Scorpio\Logs"

  Scenario: Verify that log usage field under log file settings is read only with response code 200
    Given I send a GET request to "http://10.102.11.228:8080/settings"
    When the response status should be "200"
    Then the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logFileLocation')].actionsAllowed.update" of type boolean and value "false"
      And the JSON response should have "$..[?(@.code=='logFileSettings')]..[?(@.code=='logFileLocation')].actionsAllowed.delete" of type boolean and value "false"
 
 
 # Update log file settings scenarios on Software Settings page i.e. PUT method scenarios for "/settings/databaseSettings/{settingCode}" service

  Scenario: Try to change keep logs value (in days) which is read only under log file settings should return response code 412
    Given I set request body to "15"
    When I send a PUT request to "http://10.102.11.228:8080/settings/logFileSettings/logsRetention"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Update operation not allowed for setting logsRetention"  

  Scenario: Try to change log file location value which is read only under log file settings should return response code 412
    Given I set request body to "C:\\SICK\\Analytics\\Scorpio\\Logs"
    When I send a PUT request to "http://10.102.11.228:8080/settings/logFileSettings/logFileLocation"
    Then the response status should be "412"
      And the JSON response should have "status" of type string that matches "PRECONDITION_FAILED"
      And the JSON response should have "message" of type string that matches "Update operation not allowed for setting logFileLocation"

  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser    