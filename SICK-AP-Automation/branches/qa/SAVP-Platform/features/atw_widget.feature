Feature: Activity Table Widget

Following user stories of ATW epic have been automated in this feature file:

 * User Story - DIV08RPCPF-12: As a user, I want to do blah blah blah so that I can get yada yada yada.
		Test Cases: DIV08RPCPF-111, DIV08RPCPF-222

=======================================================================================================================================================================================================================================================

# DIV08RPCPF-375
  @pending
  Scenario: Verify that the title text of ATW is displayed as Package Activity
    Given I am on the default overview dashboard
	When I see the Activity Table widget
	Then I should see the title of ATW as "Package Activity"

# DIV08RPCPF-376
  @pending
  Scenario: Verify the presence of a button in ATW to toggle between Play/Pause modes 
    Given I am on the default overview dashboard
	When I see the Activity Table widget
	Then I should see a button to toggle ATW between Play/Pause modes

# DIV08RPCPF-377
  @pending
  Scenario: Verify that ATW stops buffering new objects when toggled to Pause mode 
    Given I am on the default overview dashboard
	When I see the Activity Table widget in Play mode
	And I click on the Pause button to toggle ATW to Pause mode
	Then I should see new objects stops buffering in ATW

# DIV08RPCPF-379
  @pending
  Scenario: Verify that ATW resumes buffering new objects when toggled to Play mode
    Given I am on the default overview dashboard
	When I see the Activity Table widget in Pause mode
	And I click on the Resume button to toggle ATW to Play mode
	Then I should see new objects starts buffering in ATW
	
# DIV08RPCPF-380
  @pending
  Scenario: Verify that a Pause button is displayed in ATW when in Play mode 
    Given I am on the default overview dashboard
	When I see the Activity Table widget in Play mode
	Then I should see a Pause button to toggle ATW to Pause mode

# DIV08RPCPF-381
  @pending
  Scenario: Verify that a Resume button is displayed in ATW when in Pause mode 
    Given I am on the default overview dashboard
	When I see the Activity Table widget in Pause mode
	Then I should see a Resume button to toggle ATW to Play mode

# DIV08RPCPF-382, DIV08RPCPF-383
  @pending
  Scenario: Verify that ATW displays activity of last 300 objects only and activity of object(s) older than 300th object gets removed from ATW
    Given I am on the default overview dashboard
	When I push test data with more than 300 objects
	Then I should see only last 300 objects in ATW
	And the activity of objects older than 300th object is removed from ATW
	
# DIV08RPCPF-384
  @pending
  Scenario Outline: Verify that ATW lists following data points under edit columns - Item ID, Time stamp, Conditions, Devices, Barcodes, Dimensions (LxWxH), Scale data (Weight) & Host message and all are selected by default
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	Then I should see data point <column_name> checked by default in edit columns modal window
	
	Examples:
	| column_name         |
	| Item ID         	  |
	| Time stamp          |
	| Conditions          |	
	| Devices         	  |
	| Barcodes        	  |
	| Dimensions (LxWxH)  |
	| Scale data (Weight) |
	| Host message 		  |
	
# DIV08RPCPF-385
  @pending
  Scenario: Verify that a column unchecked under edit columns gets removed from ATW 
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	And I uncheck column "Barcodes" in edit columns modal window and save
	Then I should not see "Barcodes" column in ATW

# DIV08RPCPF-386
  @pending
  Scenario: Verify that a column "Package ID" cannot be unchecked under edit columns from ATW 
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	Then I cannot uncheck column "Package ID" in edit columns modal window and save

# DIV08RPCPF-387
  @pending
  Scenario: Verify that a column "Package ID" cannot be unchecked under edit columns from ATW 
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	And I uncheck column "Barcodes" in edit columns modal window and cancel
	Then I should still see "Barcodes" column in ATW

# DIV08RPCPF-388
  @pending
  Scenario: Verify that a column "Package ID" cannot be unchecked under edit columns from ATW 
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	Then the save button should be inactive/grayed out by default

# DIV08RPCPF-441
  @pending
  Scenario Outline: Verify that a unit for dimensions & scale data column is displayed in parenthesis based on current unit configuration 
    Given I am on the default overview dashboard
	When I set the unit configuration to "<unit_config>"
	Then I should see dimensions in "<dimension_unit>"
	And I should see scale data in "<scale_unit>"
	
	Examples:
	| unit_config   | dimension_unit | scale_unit |
	| metric        | mm			 | kg		  |
	| imperial-inch | inch 			 | lbs		  |
	| imperial-foot | foot 			 | lbs		  |

# DIV08RPCPF-635
  @pending
  Scenario Outline: Verify that full content of any column entry is displayed in a tool tip on hovering the mouse over it 
    Given I am on the default overview dashboard
	When I hover my mouse over the content entry in first row of "<column_name>" column
	Then I should see the full content of that column entry in a tool tip
	
	Examples:
	| column_name         |
	| Item ID         	  |
	| Time stamp          |
	| Conditions          |	
	| Devices         	  |
	| Barcodes        	  |
	| Dimensions (LxWxH)  |
	| Scale data (Weight) |
	| Host message 		  |
	
# DIV08RPCPF-636
  @pending
  Scenario: Verify that a column order rearranged under edit columns gets reflected in ATW 
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	And I rearrange the order of column "Conditions" and move it to the end of the list
	And I rearrange the order of column "Devices" and move it to the top of the list
	Then the "Conditions" column becomes the right-most column in ATW
	And the "Devices" column becomes the left-most column in ATW
	
# DIV08RPCPF-638
  @pending
  Scenario: Verify the presence of a button in ATW to filter object activity by condition(s) 
    Given I am on the default overview dashboard
	When I see the Activity Table widget
	Then I should see the button to filter object activity by conditions
	
# DIV08RPCPF-639
  @pending
  Scenario: Verify that the filter by condition(s) drop-down has all available conditions with check-boxes
    Given I am on the default overview dashboard
	When I click on the filter by condition drop-down
	Then I should see all available conditions with check-boxes in the drop-down
	
# DIV08RPCPF-640
  @pending
  Scenario: Verify that a if conditions column is unchecked under edit columns than filter by conditions drop-down gets removed from ATW 
    Given I am on the default overview dashboard
	When I click on the edit columns button in ATW
	And I uncheck column "Conditions" in edit columns modal window and save
	Then I should not see the button to filter object activity by conditions
	
# DIV08RPCPF-641
  @pending
  Scenario: Verify that on filtering the activity by conditions only those objects that meets all the selected conditions are displayed in ATW
    Given I am on the default overview dashboard
	When I click on the filter by condition drop-down
	And I select "ValidRead, ValidWeight, ValidDim" conditions from filter by confitions drop-down
	Then I should see only those objects in ATW that meets all the selected conditions
	
# DIV08RPCPF-642
  @pending
  Scenario: Verify that on filtering the activity by conditions object activity in ATW is refreshed and starts streaming filtered object activity
    Given I am on the default overview dashboard
	When I click on the filter by condition drop-down
	And I select "ValidRead, ValidWeight, ValidDim" conditions from filter by confitions drop-down
	Then the previous object activity gets cleared and filtered object activity starts streaming