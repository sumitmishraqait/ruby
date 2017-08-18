Feature: Data Acquisition and Control component

Following user stories of DAQC epic have been automated in this feature file:

 * User Story - DIV08RPCPF-XX: As a user, I want to do blah blah blah so that I can get yada yada yada.
		Test Cases: DIV08RPCPF-111, DIV08RPCPF-222

=======================================================================================================================================================================================================================================================

  Scenario: Verify that the test instance is up and running.
  	Given I navigate to "http://10.102.11.224:8080/"
  	And I wait for 5 sec
#	Then I should see IL Core application dashboard

  @ObjSim
  Scenario: Verify that length of each object is being streamed over websocket and its value matches with XML.
  	Given I navigate to "http://10.102.11.224:8080/"
    When I connect to websocket and subscribe to "length" channel
    Then the "length" value from websocket for each object should be same as in source XML

#  @ObjSim
#  Scenario: Verify that width of each object is being streamed over websocket and its value matches with XML.
#  	Given I navigate to "http://10.102.11.224:8080/"
#    When I connect to websocket and subscribe to "width" channel
#    Then the "width" value from websocket for each object should be same as in source XML
#      
#  @ObjSim
#  Scenario: Verify that height of each object is being streamed over websocket and its value matches with XML.
#  	Given I navigate to "http://10.102.11.224:8080/"
#    When I connect to websocket and subscribe to "height" channel			
#    Then the "height" value from websocket for each object should be same as in source XML
#      
#  @ObjSim
#  Scenario: Verify that speed of each object is being streamed over websocket and its value matches with XML.
#  	Given I navigate to "http://10.102.11.224:8080/"
#    When I connect to websocket and subscribe to "speed" channel
#    Then the "speed" value from websocket for each object should be same as in source XML

# @pending @ObjSim
#  Scenario: Verify that speed of each object is being streamed over websocket and its value matches with XML.
#  	Given I navigate to "http://10.102.11.224:8080/"
#    When I connect to websocket and subscribe to "atw" channel
#    Then the "atw" value from websocket for each object should be same as in source XML
    		
#  Scenario: Push test data to IL Core's DACQ and validate that objectdata got stored in Cassandra DB.
#    Given I push the test "objectdata" to simulators stated in configuration file "scenario1_sims_config.yaml"
#	When I query objects for "system_name" 01 in table "system_objectdata" under keyspace "sick_il" of Cassandra DB's "10.102.11.224" instance
#	Then I should see the test data getting recorded in that database

#  @pending
#  Scenario: Push test data to IL Core's DACQ and validate that heartbeatdata got stored in Cassandra DB.
#    Given I push the test "heartbeatdata" to simulators stated in configuration file "scenario1_sims_config.yaml"
#	When I query table "system_raw_data" under keyspace "sick_il" of Cassandra DB's "10.102.11.224" instance
#	Then I should see the raw test data getting recorded in that database
	
  Scenario: Print test configuration & close the browser
	Then I print configuration
	And I close browser