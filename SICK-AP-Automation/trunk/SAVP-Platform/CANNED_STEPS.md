# Canned Steps for end to end functional automation via browser

selenium-cucumber comes with the following set of predefined steps.
You can add your own steps or change the ones you see here.


* [Navigation Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#navigation-steps)
* [Assertion Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#assertion-steps)
* [Input Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#input-steps)
* [Click Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#click-steps)
* [Progress Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#progress-steps)
* [Screenshot Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#screenshot-steps)
* [Configuration Steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#configuration-steps)
* [Mobile steps](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md#mobile-steps)



## Navigation Steps

To open/close URL and to navigate between pages use following steps :

	Then I navigate to "([^\"]*)"
	Then I navigate forward
	Then I navigate back
	Then I refresh page

To switch between windows use following steps :

	Then I switch to new window
	Then I switch to previous window
	Then I switch to window having title "(.*?)"
	Then I switch to window having url "(.*?)"
	Then I close new window
	Then I switch to main window

To switch between frames use following steps :

	Then I switch to frame "(.*?)"
	Then I switch to main content

To interact with browser use following steps :

	Then I resize browser window size to width (\d+) and height (\d+)
	Then I maximize browser window
	Then I close browser

To zoom in/out webpage use following steps :

	Then I zoom in page
	Then I zoom out page

To zoom out webpage till necessary element displays use following steps :

	Then I zoom out page till I see element having id "(.*?)"
	Then I zoom out page till I see element having name "(.*?)"
	Then I zoom out page till I see element having class "(.*?)"
	Then I zoom out page till I see element having xpath "(.*?)"
	Then I zoom out page till I see element having css "(.*?)"

To reset webpage view use following step :

	Then I reset page view

To scroll webpage use following steps :

	Then I scroll to top of page
	Then I scroll to end of page

To scroll webpage to specific element use following steps :

	Then I scroll to element having id "(.*?)"
	Then I scroll to element having name "(.*?)"
	Then I scroll to element having class "(.*?)"
	Then I scroll to element having xpath "(.*?)"
	Then I scroll to element having css "(.*?)"

To hover over a element use following steps :

	Then I hover over element having id "(.*?)"
	Then I hover over element having name "(.*?)"
	Then I hover over element having class "(.*?)"
	Then I hover over element having xpath "(.*?)"
	Then I hover over element having css "(.*?)"


Assertion Steps
---------------
To assert that page title can be found use following step :

	Then I should see page title as "(.*?)"
	Then I should not see page title as "(.*?)"

	Then I should see page title having partial text as "(.*?)"
    Then I should not see page title having partial text as "(.*?)"

#### Steps For Asserting Element Text

To assert element text use any of the following steps :

	Then element having id "([^\"]*)" should have text as "(.*?)"
	Then element having name "([^\"]*)" should have text as "(.*?)"
	Then element having class "([^\"]*)" should have text as "(.*?)"
	Then element having xpath "([^\"]*)" should have text as "(.*?)"
	Then element having css "([^\"]*)" should have text as "(.*?)"

	Then element having id "([^\"]*)" should have partial text as "(.*?)"
	Then element having name "([^\"]*)" should have partial text as "(.*?)"
	Then element having class "([^\"]*)" should have partial text as "(.*?)"
	Then element having xpath "([^\"]*)" should have partial text as "(.*?)"
	Then element having css "([^\"]*)" should have partial text as "(.*?)"

	Then element having id "([^\"]*)" should not have text as "(.*?)"
	Then element having name "([^\"]*)" should not have text as "(.*?)"
	Then element having class "([^\"]*)" should not have text as "(.*?)"
	Then element having xpath "([^\"]*)" should not have text as "(.*?)"
	Then element having css "([^\"]*)" should not have text as "(.*?)"

	Then element having id "([^\"]*)" should not have partial text as "(.*?)"
	Then element having name "([^\"]*)" should not have partial text as "(.*?)"
	Then element having class "([^\"]*)" should not have partial text as "(.*?)"
	Then element having xpath "([^\"]*)" should not have partial text as "(.*?)"
	Then element having css "([^\"]*)" should not have partial text as "(.*?)"

#### Steps For Asserting Element Attribute

To assert element attribute use any of the following steps :

	Then element having id "([^\"]*)" should have attribute "(.*?)" with value "(.*?)"
	Then element having name "([^\"]*)" should have attribute "(.*?)" with value "(.*?)"
	Then element having class "([^\"]*)" should have attribute "(.*?)" with value "(.*?)"
	Then element having xpath "([^\"]*)" should have attribute "(.*?)" with value "(.*?)"
	Then element having css "([^\"]*)" should have attribute "(.*?)" with value "(.*?)"

	Then element having id "([^\"]*)" should not have attribute "(.*?)" with value "(.*?)"
	Then element having name "([^\"]*)" should not have attribute "(.*?)" with value "(.*?)"
	Then element having class "([^\"]*)" should not have attribute "(.*?)" with value "(.*?)"
	Then element having xpath "([^\"]*)" should not have attribute "(.*?)" with value "(.*?)"
	Then element having css "([^\"]*)" should not have attribute "(.*?)" with value "(.*?)"


#### Steps For Asserting Element Accesibility

To assert that element is enabled use any of the following steps :

	Then element having id "([^\"]*)" should be enabled
	Then element having name "([^\"]*)" should be enabled
	Then element having class "([^\"]*)" should be enabled
	Then element having xpath "([^\"]*)" should be enabled
	Then element having css "([^\"]*)" should be enabled

To assert that element is disabled use any of the following steps :

	Then element having id "([^\"]*)" should be disabled
	Then element having name "([^\"]*)" should be disabled
	Then element having class "([^\"]*)" should be disabled
	Then element having xpath "([^\"]*)" should be disabled
	Then element having css "([^\"]*)" should be disabled

#### Steps For Asserting Element Visibility

To assert that element is present use any of the following steps :

	Then element having id "([^\"]*)" should be present
	Then element having name "([^\"]*)" should be present
	Then element having class "([^\"]*)" should be present
	Then element having xpath "([^\"]*)" should be present
	Then element having css "([^\"]*)" should be present

To assert that element is not present use any of the following steps:

	Then element having id "([^\"]*)" should not be present
	Then element having name "([^\"]*)" should not be present
	Then element having class "([^\"]*)" should not be present
	Then element having xpath "([^\"]*)" should not be present
	Then element having css "([^\"]*)" should not be present

#### Steps For Asserting Checkbox

To assert that checkbox is checked use any of the following steps :

	Then checkbox having id "(.*?)" should be checked
	Then checkbox having name "(.*?)" should be checked
	Then checkbox having class "(.*?)" should be checked
	Then checkbox having xpath "(.*?)" should be checked
	Then checkbox having css "(.*?)" should be checked

To assert that checkbox is unchecked use any of the following steps :

	Then checkbox having id "(.*?)" should be unchecked
	Then checkbox having name "(.*?)" should be unchecked
	Then checkbox having class "(.*?)" should be unchecked
	Then checkbox having xpath "(.*?)" should be unchecked
	Then checkbox having css "(.*?)" should be unchecked

#### Steps For Asserting Dropdown List

To assert that option by text from dropdown list selected use following steps :

	Then option "(.*?)" by text from dropdown having id "(.*?)" should be selected
	Then option "(.*?)" by text from dropdown having name "(.*?)" should be selected
	Then option "(.*?)" by text from dropdown having class "(.*?)" should be selected
	Then option "(.*?)" by text from dropdown having xpath "(.*?)" should be selected
	Then option "(.*?)" by text from dropdown having css "(.*?)" should be selected

To assert that option by value from dropdown list selected use following steps :

	Then option "(.*?)" by value from dropdown having id "(.*?)" should be selected
	Then option "(.*?)" by value from dropdown having name "(.*?)" should be selected
	Then option "(.*?)" by value from dropdown having class "(.*?)" should be selected
	Then option "(.*?)" by value from dropdown having xpath "(.*?)" should be selected
	Then option "(.*?)" by value from dropdown having css "(.*?)" should be selected

To assert that option by text from dropdown list unselected use following steps :

	Then option "(.*?)" by text from dropdown having id "(.*?)" should be unselected
	Then option "(.*?)" by text from dropdown having name "(.*?)" should be unselected
	Then option "(.*?)" by text from dropdown having class "(.*?)" should be unselected
	Then option "(.*?)" by text from dropdown having xpath "(.*?)" should be unselected
	Then option "(.*?)" by text from dropdown having css "(.*?)" should be unselected

To assert that option by value from dropdown list unselected use following steps :

	Then option "(.*?)" by value from dropdown having id "(.*?)" should be unselected
	Then option "(.*?)" by value from dropdown having name "(.*?)" should be unselected
	Then option "(.*?)" by value from dropdown having class "(.*?)" should be unselected
	Then option "(.*?)" by value from dropdown having xpath "(.*?)" should be unselected
	Then option "(.*?)" by value from dropdown having css "(.*?)" should be unselected

#### Steps For Asserting Radio Button

To assert that radio button selected use any of the following steps :

	Then radio button having id "(.*?)" should be selected
	Then radio button having name "(.*?)" should be selected
	Then radio button having class "(.*?)" should be selected
	Then radio button having xpath "(.*?)" should be selected
	Then radio button having css "(.*?)" should be selected

To assert that radio button not selected use any of the following steps :

	Then radio button having id "(.*?)" should be unselected
	Then radio button having name "(.*?)" should be unselected
	Then radio button having class "(.*?)" should be unselected
	Then radio button having xpath "(.*?)" should be unselected
	Then radio button having css "(.*?)" should be unselected

To assert that radio button group selected by text use any of the following steps :

	Then option "(.*?)" by text from radio button group having id "(.*?)" should be selected
	Then option "(.*?)" by text from radio button group having name "(.*?)" should be selected
	Then option "(.*?)" by text from radio button group having class "(.*?)" should be selected
	Then option "(.*?)" by text from radio button group having xpath "(.*?)" should be selected
	Then option "(.*?)" by text from radio button group having css "(.*?)" should be selected

To assert that radio button group selected by value use any of the following steps :

	Then option "(.*?)" by value from radio button group having id "(.*?)" should be selected
	Then option "(.*?)" by value from radio button group having name "(.*?)" should be selected
	Then option "(.*?)" by value from radio button group having class "(.*?)" should be selected
	Then option "(.*?)" by value from radio button group having xpath "(.*?)" should be selected
	Then option "(.*?)" by value from radio button group having css "(.*?)" should be selected

To assert that radio button group not selected by text use any of the following steps :

	Then option "(.*?)" by text from radio button group having id "(.*?)" should be unselected
	Then option "(.*?)" by text from radio button group having name "(.*?)" should be unselected
	Then option "(.*?)" by text from radio button group having class "(.*?)" should be unselected
	Then option "(.*?)" by text from radio button group having xpath "(.*?)" should be unselected
	Then option "(.*?)" by text from radio button group having css "(.*?)" should be unselected

To assert that radio button group not selected by value use any of the following steps :

	Then option "(.*?)" by value from radio button group having id "(.*?)" should be unselected
	Then option "(.*?)" by value from radio button group having name "(.*?)" should be unselected
	Then option "(.*?)" by value from radio button group having class "(.*?)" should be unselected
	Then option "(.*?)" by value from radio button group having xpath "(.*?)" should be unselected
	Then option "(.*?)" by value from radio button group having css "(.*?)" should be unselected

#### Steps For Asserting Links

To assert that link is present use following steps :

	Then link having text "(.*?)" should be present
	Then link having partial text "(.*?)" should be present

To assert that link is not present use following steps :

	Then link having text "(.*?)" should not be present
	Then link having partial text "(.*?)" should not be present

#### Steps For Asserting Javascript Pop-Up Alert

To assert text on javascipt pop-up alert use following step :

	Then I should see alert text as "(.*?)"

#### Steps For Asserting Difference in images

To assert difference in actual image and expected image (from remotely hosted) use following steps :

	Then actual image having id "(.*?)" and expected image having url "(.*?)" should be similar
	Then actual image having name "(.*?)" and expected image having url "(.*?)" should be similar
	Then actual image having class "(.*?)" and expected image having url "(.*?)" should be similar
	Then actual image having xpath "(.*?)" and expected image having url "(.*?)" should be similar
	Then actual image having css "(.*?)" and expected image having url "(.*?)" should be similar
	Then actual image having url "(.*?)" and expected image having url "(.*?)" should be similar

To assert difference in actual image and expected image (from local machine) use following steps :

	Then actual image having id "(.*?)" and expected image having image_name "(.*?)" should be similar
	Then actual image having name "(.*?)" and expected image having image_name "(.*?)" should be similar
	Then actual image having class "(.*?)" and expected image having image_name "(.*?)" should be similar
	Then actual image having xpath "(.*?)" and expected image having image_name "(.*?)" should be similar
	Then actual image having css "(.*?)" and expected image having image_name "(.*?)" should be similar
	Then actual image having url "(.*?)" and expected image having image_name "(.*?)" should be similar

To assert difference in actual image and expected image (from same webpage) use following steps :

	Then actual image having id "(.*?)" and expected image having id "(.*?)" should be similar
	Then actual image having name "(.*?)" and expected image having name "(.*?)" should be similar
	Then actual image having class "(.*?)" and expected image having class "(.*?)" should be similar
	Then actual image having xpath "(.*?)" and expected image having xpath "(.*?)" should be similar
	Then actual image having css "(.*?)" and expected image having css "(.*?)" should be similar
	Then actual image having url "(.*?)" and expected image having url "(.*?)" should be similar


Input Steps
-----------

#### Steps For TextFields

To enter text into input field use following steps :

	Then I enter "([^\"]*)" into input field having id "([^\"]*)"
	Then I enter "([^\"]*)" into input field having name "([^\"]*)"
	Then I enter "([^\"]*)" into input field having class "([^\"]*)"
	Then I enter "([^\"]*)" into input field having xpath "([^\"]*)"
	Then I enter "([^\"]*)" into input field having css "([^\"]*)"

To clear input field use following steps :

	Then I clear input field having id "([^\"]*)"
	Then I clear input field having name "([^\"]*)"
	Then I clear input field having class "([^\"]*)"
	Then I clear input field having xpath "([^\"]*)"
	Then I clear input field having css "([^\"]*)"

#### Steps For Dropdown List

To select option by text from dropdown use following steps :

	Then I select "(.*?)" option by text from dropdown having id "(.*?)"
	Then I select "(.*?)" option by text from dropdown having name "(.*?)"
	Then I select "(.*?)" option by text from dropdown having class "(.*?)"
	Then I select "(.*?)" option by text from dropdown having xpath "(.*?)"
	Then I select "(.*?)" option by text from dropdown having css "(.*?)"

To select option by index from dropdown use following steps :

	Then I select (\d+) option by index from dropdown having id "(.*?)"
	Then I select (\d+) option by index from dropdown having name "(.*?)"
	Then I select (\d+) option by index from dropdown having class "(.*?)"
	Then I select (\d+) option by index from dropdown having xpath "(.*?)"
	Then I select (\d+) option by index from dropdown having css "(.*?)"

To select option by value from dropdown use following steps :

	Then I select "(.*?)" option by value from dropdown having id "(.*?)"
	Then I select "(.*?)" option by value from dropdown having name "(.*?)"
	Then I select "(.*?)" option by value from dropdown having class "(.*?)"
	Then I select "(.*?)" option by value from dropdown having xpath "(.*?)"
	Then I select "(.*?)" option by value from dropdown having css "(.*?)"

#### Steps For Multiselect List

To select option by text from multiselect dropdown use following steps :

	Then I select "(.*?)" option by text from multiselect dropdown having id "(.*?)"
	Then I select "(.*?)" option by text from multiselect dropdown having name "(.*?)"
	Then I select "(.*?)" option by text from multiselect dropdown having class "(.*?)"
	Then I select "(.*?)" option by text from multiselect dropdown having xpath "(.*?)"
	Then I select "(.*?)" option by text from multiselect dropdown having css "(.*?)"

To select option by index from multiselect dropdown use following steps :

	Then I select (\d+) option by index from multiselect dropdown having id "(.*?)"
	Then I select (\d+) option by index from multiselect dropdown having name "(.*?)"
	Then I select (\d+) option by index from multiselect dropdown having class "(.*?)"
	Then I select (\d+) option by index from multiselect dropdown having xpath "(.*?)"
	Then I select (\d+) option by index from multiselect dropdown having css "(.*?)"

To select option by value from multiselect dropdown use following steps :

	Then I select "(.*?)" option by value from multiselect dropdown having id "(.*?)"
	Then I select "(.*?)" option by value from multiselect dropdown having name "(.*?)"
	Then I select "(.*?)" option by value from multiselect dropdown having class "(.*?)"
	Then I select "(.*?)" option by value from multiselect dropdown having xpath "(.*?)"
	Then I select "(.*?)" option by value from multiselect dropdown having css "(.*?)"

To select all options from multiselect use following steps :

	Then I select all options from multiselect dropdown having id "(.*?)"
	Then I select all options from multiselect dropdown having name "(.*?)"
	Then I select all options from multiselect dropdown having class "(.*?)"
	Then I select all options from multiselect dropdown having xpath "(.*?)"
	Then I select all options from multiselect dropdown having css "(.*?)"

To unselect all options from multiselect use following steps :

	Then I unselect all options from mutliselect dropdown having id "(.*?)"
	Then I unselect all options from mutliselect dropdown having name "(.*?)"
	Then I unselect all options from mutliselect dropdown having class "(.*?)"
	Then I unselect all options from mutliselect dropdown having xpath "(.*?)"
	Then I unselect all options from mutliselect dropdown having css "(.*?)"

#### Steps For Checkboxes

To check the checkbox use following steps :

	Then I check the checkbox having id "(.*?)"
	Then I check the checkbox having name "(.*?)"
	Then I check the checkbox having class "(.*?)"
	Then I check the checkbox having xpath "(.*?)"
	Then I check the checkbox having css "(.*?)"

To uncheck the checkbox use following steps :

	Then I uncheck the checkbox having id "(.*?)"
	Then I uncheck the checkbox having name "(.*?)"
	Then I uncheck the checkbox having class "(.*?)"
	Then I uncheck the checkbox having xpath "(.*?)"
	Then I uncheck the checkbox having css "(.*?)"

To toggle checkbox use following steps

	Then I toggle checkbox having id "(.*?)"
	Then I toggle checkbox having name "(.*?)"
	Then I toggle checkbox having class "(.*?)"
	Then I toggle checkbox having xpath "(.*?)"
	Then I toggle checkbox having css "(.*?)"

#### Steps For Radio Buttons

To select radio button use following steps :

	Then I select radio button having id "(.*?)"
	Then I select radio button having name "(.*?)"
	Then I select radio button having class "(.*?)"
	Then I select radio button having xpath "(.*?)"
	Then I select radio button having css "(.*?)"


To select one radio button by text from radio button group use following steps :

	Then I select "(.*?)" option by text from radio button group having id "(.*?)"
	Then I select "(.*?)" option by text from radio button group having name "(.*?)"
	Then I select "(.*?)" option by text from radio button group having class "(.*?)"
	Then I select "(.*?)" option by text from radio button group having xpath "(.*?)"
	Then I select "(.*?)" option by text from radio button group having css "(.*?)"

To select one radio button by value from radio button group use following steps :

	Then I select "(.*?)" option by value from radio button group having id "(.*?)"
	Then I select "(.*?)" option by value from radio button group having name "(.*?)"
	Then I select "(.*?)" option by value from radio button group having class "(.*?)"
	Then I select "(.*?)" option by value from radio button group having xpath "(.*?)"
	Then I select "(.*?)" option by value from radio button group having css "(.*?)"


Click Steps
-----------
To click on web element use following steps :

	Then I click on element having id "(.*?)"
	Then I click on element having name "(.*?)"
	Then I click on element having class "(.*?)"
	Then I click on element having xpath "(.*?)"
	Then I click on element having css "(.*?)"

To click on web element with a particular text use the following steps :

	Then I click on element having id "(.*?)" and text "(.*?)"
	Then I click on element having name "(.*?)" and text "(.*?)"
	Then I click on element having class "(.*?)" and text "(.*?)"
	Then I click on element having xpath "(.*?)" and text "(.*?)"
	Then I click on element having css "(.*?)" and text "(.*?)"

To forcefully click on web element use following steps (if above steps do not work) :

	Then I forcefully click on element having id "(.*?)"
	Then I forcefully click on element having name "(.*?)"
	Then I forcefully click on element having class "(.*?)"
	Then I forcefully click on element having xpath "(.*?)"
	Then I forcefully click on element having css "(.*?)"

To double click on web element use following steps :

	Then I double click on element having id "(.*?)"
	Then I double click on element having name "(.*?)"
	Then I double click on element having class "(.*?)"
	Then I double click on element having xpath "(.*?)"
	Then I double click on element having css "(.*?)"

To click on links use following steps :

	Then I click on link having text "(.*?)"
	Then I click on link having partial text "(.*?)"

Progress Steps
--------------
To wait for specific time use following step :

	Then I wait for (\d+) sec

To wait for specific element to display use following steps :

	Then I wait (\d+) seconds for element having id "(.*?)" to display
	Then I wait (\d+) seconds for element having name "(.*?)" to display
	Then I wait (\d+) seconds for element having class "(.*?)" to display
	Then I wait (\d+) seconds for element having xpath "(.*?)" to display
	Then I wait (\d+) seconds for element having css "(.*?)" to display

To wait for specific element to enable use following steps :

	Then I wait (\d+) seconds for element having id "(.*?)" to enable
	Then I wait (\d+) seconds for element having name "(.*?)" to enable
	Then I wait (\d+) seconds for element having class "(.*?)" to enable
	Then I wait (\d+) seconds for element having xpath "(.*?)" to enable
	Then I wait (\d+) seconds for element having css "(.*?)" to enable

Javascript Handling Steps
-------------------------
To handle javascript pop-up use following steps :

	Then I accept alert
	Then I dismiss alert


Screenshot Steps
----------------
To take screenshot use following step :

	Then I take screenshot


Configuration Steps
-------------------
To print testing configuration use following step :

	Then I print configuration

## Mobile Steps


### Tap Steps
-----------
To tap on app element use following steps :

	Then I tap on element having id "(.*?)"
	Then I tap on element having name "(.*?)"
	Then I tap on element having class "(.*?)"
	Then I tap on element having xpath "(.*?)"
	Then I tap on element having css "(.*?)"

To Tap on back button of device	use following step :

    Then I tap on back button of device
    Then I press back button of device

### Gesture Steps
------------
To perform gesture operations on device

### Swipe steps
------------
To perform swipe using app elements use following steps :

    Then I swipe from element having id "(.*?)" to element having id "(.*?)"
    Then I swipe from element having id "(.*?)" to element having name "(.*?)"
    Then I swipe from element having id "(.*?)" to element having class "(.*?)"
    Then I swipe from element having id "(.*?)" to element having xpath "(.*?)"

    Then I swipe from element having name "(.*?)" to element having id "(.*?)"
    Then I swipe from element having name "(.*?)" to element having name "(.*?)"
    Then I swipe from element having name "(.*?)" to element having class "(.*?)"
    Then I swipe from element having name "(.*?)" to element having xpath "(.*?)"

    Then I swipe from element having class "(.*?)" to element having id "(.*?)"
    Then I swipe from element having class "(.*?)" to element having name "(.*?)"
    Then I swipe from element having class "(.*?)" to element having class "(.*?)"
    Then I swipe from element having class "(.*?)" to element having xpath "(.*?)"

    Then I swipe from element having xpath "(.*?)" to element having id "(.*?)"
    Then I swipe from element having xpath "(.*?)" to element having name "(.*?)"
    Then I swipe from element having xpath "(.*?)" to element having class "(.*?)"
    Then I swipe from element having xpath "(.*?)" to element having xpath "(.*?)"

To perform swipe using co-ordinates

    Then I swipe from co-ordinates "(.*?)","(.*?)" to co-ordinates "(.*?)","(.*?)"

To perform swipe using direction

    Then I swipe right
    Then I swipe left
    Then I swipe up
    Then I swipe down

To perform swipe using app element with direction use following steps :

    Then I swipe element having id "(.*?)" to right
    Then I swipe element having name "(.*?)" to right
    Then I swipe element having class "(.*?)" to right
    Then I swipe element having xpath "(.*?)" to right

    Then I swipe element having id "(.*?)" to left
    Then I swipe element having name "(.*?)" to left
    Then I swipe element having class "(.*?)" to left
    Then I swipe element having xpath "(.*?)" to left

    Then I swipe element having id "(.*?)" to up
    Then I swipe element having name "(.*?)" to up
    Then I swipe element having class "(.*?)" to up
    Then I swipe element having xpath "(.*?)" to up

    Then I swipe element having id "(.*?)" to down
    Then I swipe element having name "(.*?)" to down
    Then I swipe element having class "(.*?)" to down
    Then I swipe element having xpath "(.*?)" to down

To perform swipe using co-ordinates with direction use following steps :

    Then I swipe co-ordinates "(.*?)","(.*?)" to left
    Then I swipe co-ordinates "(.*?)","(.*?)" to right
    Then I swipe co-ordinates "(.*?)","(.*?)" to up
    Then I swipe co-ordinates "(.*?)","(.*?)" to down


### long tap steps
------------
To perform long tap with default duration of 2 seconds on app elements use following steps :

	Then I long tap on element having id "(.*?)"
	Then I long tap on element having name "(.*?)"
  	Then I long tap on element having class "(.*?)"
  	Then I long tap on element having xpath "(.*?)"

To perform long tap with customized duration of seconds on app elements use following steps :

  	Then I long tap on element having id "(.*?)" for "(.*?)" sec
  	Then I long tap on element having name "(.*?)" for "(.*?)" sec
  	Then I long tap on element having class "(.*?)" for "(.*?)" sec
  	Then I long tap on element having xpath "(.*?)" for "(.*?)" sec

To perform long tap with default duration of 2 seconds using co-ordinates use following step :

  	Then I long tap on co\-ordinate "(.*?)","(.*?)

To perform long tap with customized duration of seconds using co-ordinates use following step :

  	Then I long tap on co\-ordinate "(.*?)","(.*?)" for "(.*?)" sec

### Close app step

  	Then I close app


## REST API Canned Steps and their Usage

### Available steps

**Preparation steps**

Specify your request header's `Content-Type` and `Accept`. The only supported option for `Accept` is `application/json` at the moment.

```gherkin
Given I send and accept JSON
Given I send "(.*?)" and accept JSON
```

You could also others header's information like:

```gherkin
Given I send and accept JSON
And I add Headers:
  | name1 | value |
  | name2 | other |
```

Specify POST body

```gherkin
When I set JSON request body to '(.*?)'
When I set form request body to:
  | key1 | value1              |
  | key2 | {value2}            |
  | key3 | file://path-to-file |
When I set JSON request body to:
"""
{
  "key1": "jsonString",
  "key2":  1
}
"""
```

Or from YAML/JSON file

```gherkin
When I set request body from "(.*?).(yml|json)"
```

Example:

```Gherkin
Given I send "www-x-form-urlencoded" and accept JSON
When I set JSON request body to '{"login": "email@example.com", "password": "password"}'
When I set form request body to:
  | login    | email@example.com     |
  | password | password              |
When I set request body from "data/json-data.json"
When I set request body from "data/form-data.yml"
```

**Request steps**

Specify query string parameters and send an HTTP request to given URL with parameters

```gherkin
When I send a (GET|POST|PATCH|PUT|DELETE) request to "(.*?)"
When I send a (GET|POST|PATCH|PUT|DELETE) request to "(.*?)" with:
  | param1 | param2 | ... |
  | value1 | value2 | ... |
```

Temporarily save values from the last request to use in subsequent steps in the same scenario:

```gherkin
When I grab "(.*?)" as "(.*?)"
```

Optionally, auto infer placeholder from grabbed JSON path:

```gherkin
# Grab and auto assign {id} as placeholder
When I grab "$..id"
```

The saved value can then be used to replace `{placeholder}` in the subsequent steps.

Example:

```gherkin
When I send a POST request to "http://example.com/token"
And I grab "$..request_token" as "token"
And I grab "$..access_type" as "type"
And I grab "$..id"
And I send a GET request to "http://example.com/{token}" with:
  | type            | pretty |
  | {type}          | true   |
Then the JSON response should have required key "id" of type string and value "{id}"
```

Assume that [http://example.com/token](http://example.com/token) have an element `{"request_token": 1, "access_type": "full", "id": "user1"}`, **cucumber-api** will execute the followings:

* POST [http://example.com/token](http://example.com/token)
* Extract the first `request_token`, `access_type` and `id` from JSON response and save it for subsequent steps
* GET [http://example.com/1?type=full&pretty=true](http://example.com/1?type=full&pretty=true)
* Verify that JSON response has a pair of JSON key-value: `"id": "user1"`
* Clear all saved values

This will be handy when one needs to make a sequence of calls to authenticate/authorize API access.

**Assert steps**

Verify:
* HTTP response status code
* JSON response against a JSON schema conforming to [JSON Schema Draft 4](http://tools.ietf.org/html/draft-zyp-json-schema-04)
* Adhoc JSON response key-value type pair, where key is a [JSON path](http://goessner.net/articles/JsonPath/)

```gherkin
Then the response status should be "(\d+)"
Then the JSON response should follow "(.*?)"
Then the JSON response root should be (object|array)
Then the JSON response should have key "([^\"]*)"
Then the JSON response should have (required|optional) key "(.*?)" of type (numeric|string|boolean|numeric_string|object|array|any)( or null)
Then the JSON response should have (required|optional) key "(.*?)" of type (numeric|string|boolean|numeric_string|object|array|any)( or null) and value "(.*?)"
```

Example:

```gherkin
Then the response status should be "200"
Then the JSON response should follow "features/schemas/example_all.json"
Then the JSON response root should be array
Then the JSON response should have key "id"
Then the JSON response should have optional key "format" of type string or null
Then the JSON response should have required key "status" of type string and value "foobar"
```

Also checkout [sample](/features/sample.feature) for real examples. Run sample with the following command:

```
cucumber -p verbose
```

### Response caching

Response caching is provided for GET requests by default. This is useful when you have a Scenario Outline or multiple Scenarios that make GET requests to the same endpoint.

Only the first request to that endpoint is made, subsequent requests will use cached response. Response caching is only available for GET method.

## Dependencies
* [cucumber](https://github.com/cucumber/cucumber) for BDD style specs
* [jsonpath](https://github.com/joshbuddy/jsonpath) for traversal of JSON response via [JSON path](http://goessner.net/articles/JsonPath/)
* [json-schema](https://github.com/ruby-json-schema/json-schema) for JSON schema validation
* [rest-client](https://github.com/rest-client/rest-client) for HTTP REST request

# Gherkin Steps

This test suite introduces behavioural test steps on top of functional REST API steps from [cucumber-api](https://github.com/hidroh/cucumber-api)

The following is a list of steps, and their equivalent functional step

## Setup

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Given I am a client                                 Given I send and accept JSON
```

## Retrieval

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request an item "2"                          When I send a GET request to "http://url/items/2"

When I request a list of items                      When I send a GET request to "http://url/items"

When I request a list of items with:                When I send a GET request to "http://url/items" with:
   | User Id | 12 |                                     | userId |
                                                        | 12     |
```

## Creation

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request to create an item                    When I send a POST request to "http://url/items"

When I request to create an item with:              When I set JSON request body to:
    | attribute | type    | value |                     """
    | User Id   | integer | 12    |                     {"userId":12,"title":"foo"}
    | Title     | string  | foo   |                     """
                                                    And I send a POST request to "http://url/items"

When I request to create an item with id "4"        When I send a PUT request to "http://url/items/4"

When I request to replace the item "4" with:        When I set JSON request body to:
    | attribute | type    | value |                     """
    | User Id   | integer | 7     |                     {"userId":7,"title":"foo"}
    | Title     | string  | foo   |                     """
                                                    And I send a PUT request to "http://url/items/4"
```

## Modification

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request to modify the item "4" with:         When I set JSON request body to:
    | attribute | type    | value |                     """
    | Body      | string  | bar   |                     {"body":"bar"}
                                                        """
                                                    And I send a PATCH request to "http://url/items/4"
```

## Status Inspection

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the request is successful                      Then the response status should be "200"

Then the request was redirected                     <N/A> (response status between "300" and "400")

Then the request failed                             <N/A> (response status between "400" and "600")

Then the request was successful and an item was     Then the response status should be "201"
  created

Then the request was successfully accepted          Then the response status should be "202"

Then the request was successful and no response     Then the response status should be "204"
  body is returned

Then the request failed because it was invalid      Then the response status should be "400"

Then the request failed because I am unauthorised   Then the response status should be "401"

Then the request failed because it was forbidden    Then the response status should be "403"

Then the request failed because the item was not    Then the response status should be "404"
  found

Then the request failed because it was not allowed  Then the response status should be "405"

Then the request failed because there was a         Then the response status should be "409"
  conflict

Then the request failed because the item has gone   Then the response status should be "410"

Then the request failed because it was not          Then the response status should be "501"
  implemented
```

## Response Inspection

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the response has the following attributes:     Then the JSON response should have "userId" of type numeric
    | attribute | type    | value |                   with value "12"
    | User Id   | integer | 12    |                 Then the JSON response should have "title" of type numeric
    | Title     | string  | foo   |                   with value "foo"
    | Body      | string  | bar   |                 Then the JSON response should have "body" of type numeric with
                                                      value "bar"

Then the response is a list of 12 items             Then the JSON response should have "$." of type array with 12
                                                      entries

Then the response is a list of at least 12 items    Then the JSON response should have "$." of type array with at
                                                      least 12 entries
Then the response is a list of at most 12 items     <N/A>
Then the response is a list of fewer than 12 items  <N/A>
Then the response is a list of more than 12 items   <N/A>

Then two items have have the following attributes:  <N/A>
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
    | Body      | string  | bar   |

Then more than two items have have the following    <N/A>
  attributes:
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
    | Body      | string  | bar   |

<N/A>                                               Then the JSON response should follow "schema.json"

<N/A>                                               Then the response has the header "Content Type" with value
                                                      "application/json"
```

### Attribute saving and re-use

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I save "User Id" as "user"                     When I grab "$.userId" as "user"
And I request the user "{user}"                     And I send a GET request to "http://url/users/{user}"
```

### Nested requests

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request a list of comments for post "1"      When I send a GET request to "http://url/posts/1/comments"

When I request the comment "2" for post "3"         When I send a GET request to "http://url/posts/2/comments/3"

When I request the photo "3" in album "4" for user  When I send a GET request to
  "5"                                                 "http://url/users/5/albums/4/photos/3"

When I request a list of photos in album "6" for    When I send a GET request to
  user "7"                                            "http://url/users/7/albums/6/photos"

When I request to create a comment for post "8"     When I send a POST request to "http://url/posts/8/comments"

When I request to modify the comment "9" for post   When I send a PATCH request to
  "10"                                                "http://url/posts/10/comments/9"

When I request to set photo "11" in album "12" to:  When I set JSON request body to:
    | attribute | type   | value                |       """
    | url       | string | http://url/image.jpg |       {"url":"http://url/image.jpg"}
                                                        """
                                                    And I send a PUT request to "http://url/albums/12/photos/11"
```

### Nested responses

```
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the response has the following attributes:     Then the JSON response should have "userId" of type numeric
    | attribute    | type    | value |                with value "12"
    | User Id      | integer | 12    |              Then the JSON response should have "title" of type numeric
    | Title        | string  | foo   |                with value "foo"
    | Body         | string  | bar   |              Then the JSON response should have "body" of type numeric with
    | Post : Title | string  | baz   |                value "bar"
    | Post : Body  | string  | boo   |              Then the JSON response should have "post.title" of type string
                                                      with value "baz"
                                                    Then the JSON response should have "post.body" of type string
                                                      with value "boo"

Then the response has a list of comments            Then the JSON response should have "comments" of type array

Then the response has a list of 2 comments          Then the JSON response should have "comments" of type array with
                                                      2 entries
Then the response has a list of at least            Then the JSON response should have "comments" of type array with
  2 comments                                          at least 2 entries

Then the response has a post with two comments      <N/A>
  with attributes:
    | attribute | type   | value |
    | Title     | string | foo   |
    | Body      | string | bar   |

Then two items contains two posts with three        <N/A>
  comments with an image with attributes:
    | attribute | type   | value    |
    | Href      | string | some_url |

Then more than two items contains fewer than two    <N/A>
  posts with at least three comments with an
  image with attributes:
    | attribute | type   | value    |
    | Href      | string | some_url |

Then the response has a post with a list of         Then the JSON response should have "post.comments" of type array
  comments

Then the response has a post with a list of more    Then the JSON response should have "post.comments" of type array
  than 3 comments                                     with at least 4 comments

Then more than three posts have less than two       <N/A>
  comments
```
