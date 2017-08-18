Feature: Conveyor Belt Widget

Following user stories of Bookmarking epic have been automated in this feature file:

 * User Story - DIV08RPCPF-12: As a user, I want to do blah blah blah so that I can get yada yada yada.
		Test Cases: DIV08RPCPF-111, DIV08RPCPF-222
		  
 * User Story - DIV08RPCPF-223: [CBW] Implement condition color coding with logic

=======================================================================================================================================================================================================================================================

# Pre-requisite scenario to login to SAVP
  Scenario: Verify that application allows user to logout from the application
    Given I am on the Login page
	When I login using valid username "self-reg-user" and password "S1cksick"
	Then I land on the home page of SAVP dashboard
		
# DIV08RPCPF-23 --> No need to automate, this test case is just to match UX with wireframe

# DIV08RPCPF-363
  Scenario Outline: Verify the presence of at least 4 pre-defined colors under color coding settings i.e. green, orange, red & blue.
    Given I am on the default overview dashboard
	When I open the color coding settings of Conveyor Belt widget
	Then I should see pre-defined <color_name> color with code "<color_code>" in it
	
	Examples:
	| color_name | color_code |
	| green      | #009688 	  |
	| orange     | #F5A623 	  |
	| red        | #D0021B 	  |
	| blue       | #0288D1 	  |
		
# DIV08RPCPF-364	
  Scenario Outline: Verify the presence of a drop-down next to each color with all available Conditions as options.
    Given I am on the default overview dashboard
	When I open the color coding settings of Conveyor Belt widget
	Then I should see a drop-down of all available Conditions next to <color_name> color with code "<color_code>"
	
	Examples:
	| color_name | color_code |
	| green      | #009688 	  |
	| orange     | #F5A623 	  |
	| red        | #D0021B 	  |
	| blue       | #0288D1 	  |

# DIV08RPCPF-365
  Scenario: Verify that application removes the Condition as an option from drop-down menus of remaining colors once it is assigned to a color.
    Given I am on the color coding settings of Conveyor Belt widget
	When I select a condition "ValidRead" from drop-down menu of green color
	Then I should not see "ValidRead" condition as a drop-down menu of any color other than green

# DIV08RPCPF-366
  Scenario: Verify that application allows the user to set conditions for colors in any order.
    Given I am on the color coding settings of Conveyor Belt widget
	When I set a condition for red color
	Then I should be able to set a condition for orange color

# DIV08RPCPF-367
  Scenario: Verify that application applies the topmost color that met the condition to the box in case an object meets multiple color coding conditions i.e. priority of color coding is top to bottom.
    Given I set conditions for all the colors in Conveyor Belt widget's color coding settings
	When I receive a box on CBW that meets multiple color coding conditions
	Then I should see the box in topmost color in color coding settings

# DIV08RPCPF-368
  Scenario: Verify that application allows the user to Save the color coding conditions with one or more color(s) still with default "None" value.
    Given I am on the color coding settings of Conveyor Belt widget
	When I set a condition for only red color
	Then I should sill be able to save the color conditions

# DIV08RPCPF-369
  Scenario: Verify that application allows the user to change the color coding condition set for any color(s) back to default "None" value.
    Given I set conditions for all the colors in Conveyor Belt widget's color coding settings
	When I select a condition "None" from drop-down menu of green color
	Then I should sill be able to save the color conditions
				
# DIV08RPCPF-XXX --> Failing due to UI locators have dynamic IDs
  @fail
  Scenario: Conveyor Belt Widget should be present
    Given I launch SAVP 4.0 web application
	When I see the "Conveyor Belt" widget
	Then I print number & attributes of the boxes on the belt

  Scenario: Print test configuration & close the browser
	Then I print configuration
	Then I close browser