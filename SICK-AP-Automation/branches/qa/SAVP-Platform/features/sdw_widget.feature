Feature: Simple Display Widget

Following user stories of SDW epic have been automated in this feature file:

 * User Story - DIV08RPCPF-12: As a user, I want to do blah blah blah so that I can get yada yada yada.
		Test Cases: DIV08RPCPF-111, DIV08RPCPF-222

=======================================================================================================================================================================================================================================================

# DIV08RPCPF-1060
  Scenario: Verify that SDW has two fields, one for label and other for content
    Given I am on the default overview dashboard
	When I see the SDW for speed data
	Then I should see a label field and a content field
	
# DIV08RPCPF-1062
  Scenario: Verify that user can edit the label text
    Given I am on the default overview dashboard
	When I click on the label field of SDW for speed data
	Then I should be able to edit the text in label field

# DIV08RPCPF-1138
  @fail
  Scenario: Verify that user cannot clear label field to make label field empty 
    Given I am on the default overview dashboard
	When I try to clear the label field to make it empty
	And I click anywhere outside the label field
	Then I should see a snackbar warning that "Title label cannot be empty"

# DIV08RPCPF-1138
  Scenario: Verify that user cannot delete all text to make label field empty 
    Given I am on the default overview dashboard
	When I try to delete all the text in label field to make it empty
	Then I should not be able to delete the last character
	And I should see a snackbar warning that "Title label cannot be empty"	

# DIV08RPCPF-1139
  @fail
  Scenario: Verify that user cannot add only blank spaces in the label field 
    Given I am on the default overview dashboard
	When I try to enter only blank spaces in label field of SDW for speed data
	Then I should see a snackbar warning that "Title label cannot be empty"
	
# DIV08RPCPF-1140
  Scenario: Verify that edited label text is saved on clicking anywhere outside the label field
    Given I am on the default overview dashboard
	When I enter "Current Belt Speed" in label field of SDW for speed data
	And I click anywhere outside the label field
	Then the edited label "Current Belt Speed" should be saved on clicking outside the label field

# DIV08RPCPF-1061
  @fail
  Scenario: Verify that longer label text gets truncated and gets appended with ellipsis (3 dots in the end)
    Given I am on the default overview dashboard
	When I enter a long label like "Belt Speed Information with a long label text" in label field of SDW for speed data
	And I click anywhere outside the label field
	Then I should see the truncated label with an ellipsis appended at the end
	
# DIV08RPCPF-1063
  Scenario: Verify that user can enter freeform text i.e. a-z, A-Z, 0-9, spaces & any special characters in the label field
    Given I am on the default overview dashboard
	When I enter a label "$P33D - !nf0rM@t~On" containing special characters, spaces, numbers & letters in upper/lower case in label field of SDW for speed data
	And I click anywhere outside the label field
	Then the edited label "$P33D - !nf0rM@t~On" should be saved on clicking outside the label field

  Scenario: Print test configuration & close the browser
	Then I print configuration
	Then I close browser