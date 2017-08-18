Feature: Testing configuration of adding and removing devices from device group

Background:
Given I am on Configuration page of SICK Analytics product page
When I click on facility configuration tab
And I enter the password
And I click on Submit button
Then I should be redirected to the Systems page
And I click on System Name  in Systems page

Scenario: Testing To add New Device group in existing system
When I click on Device Group tab on System view
And I click on + Icon of the page
Then I should see the Add New Group modal box with following title:
|Group name |
|NoRead Limit|
And I should enter the Group name and Noread limit
And I click on Next button
And I should view the devices in sorted manner
And I should view a  Add New group with "Add New Group" heading
And I check the device in Add New group
And I click on Next button
And I click on Save button

Scenario: Testing to remove an Existing Device from Device Group
When I click on Device Group tab on System view
And I click on X on  Device group  list
Then The device should be removed

Scenario: Testing to remove last Existing Device from Device group
When I click on Device Group tab on System view
And I click on X on  Device group  list
And IF the device is the last device in list
Then The device should  show a Warning pop up header "Removing Last Device" on screen
