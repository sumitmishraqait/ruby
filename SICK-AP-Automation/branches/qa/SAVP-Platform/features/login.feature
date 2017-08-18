Feature: Login, Forgot Password, Sign Up and Logout screens.

Following user stories of Bookmarking epic have been automated in this feature file:

 * User Story - DIV08RPCPF-117: [Login] Master user story for Login module UI development tasks

=======================================================================================================================================================================================================================================================
# DIV08RPCPF-321
  Scenario: Verify the presence of SICK logo with "Warehouse Analytics" text on login page
    Given I launch SAVP 4.0 web application
	When I land on the Login page
	Then I should see SICK logo with text "Warehouse Analytics" below it

# DIV08RPCPF-322	
  Scenario Outline: Verify the presence of form fields, buttons and links on login page
    Given I launch SAVP 4.0 web application
	When I land on the Login page
	Then I should see <field_name> <field_type> on login page
	
	Examples:
	| field_name       | field_type  |
	| Username         | input field |
	| Password         | input field |
	| Sign In          | button      |
	| Remember Me      | checkbox    |
	| Forgot Password? | link        |
	| Sign Up          | link        |

# DIV08RPCPF-322 --> No need to automate, this test case is just to match UX with wireframe
	
# DIV08RPCPF-324
  Scenario: Verify that application trims leading/ trailing spaces and/or white-spaces between username when entered in the Username input field on login screen
    Given I am on the Login page
	When I enter text " user name " which has leading/ trailing spaces and white-spaces in between in Username field on login screen
	Then Application should trim those leading/ trailing & white spaces and make username value "username"

# DIV08RPCPF-325
  Scenario: Verify that "Sign In" button remains grayed-out/ inactive until username and/or password field(s) are left blank
    Given I am on the Login page
	When I leave username and password fields blank
	Then "Sign In" button should remain grayed-out/ inactive
	When I enter "admin" in username field but leave password field blank
	Then "Sign In" button should remain grayed-out/ inactive
	When I enter "sicksick" in password field but leave username field blank
	Then "Sign In" button should remain grayed-out/ inactive	

# DIV08RPCPF-327
  Scenario: Verify that application throws error on entering incorrect username/ password combination
    Given I am on the Login page
	When I enter "admin" in username field on login screen
	And I enter "wrongpassword" in password field on login screen
	And I click on the Sign In button to login
	Then Application should throw an error "Username or password is incorrect" on login page

# DIV08RPCPF-328
  Scenario: Verify that application allows user to login with valid username and password combination
    Given I am on the Login page
	When I enter "admin" in username field on login screen
	And I enter "sicksick" in password field on login screen
	And I click on the Sign In button to login
	Then I land on the home page of SAVP dashboard
	
# DIV08RPCPF-329
  Scenario: Verify that "Forgot Password?" link on login page when clicked navigates to forgot password screen
    Given I am on the Login page
	When I click on the "Forgot Password?" link on login page
	Then I land on forgot password screen

# DIV08RPCPF-330
  Scenario: Verify that "Sign Up" link on login page when clicked navigates to self-registration screen
    Given I am on the Login page
	When I click on the "Sign Up" link on login page
	Then I land on self-registration screen

# DIV08RPCPF-331
  Scenario: Verify that application navigates user back to login screen on clicking "Cancel" link on forgot password screen
    Given I am on the Login page
	When I click on the "Sign Up" link on login page
	And I click on the "cancel" link on forgot password screen
	Then I should be redirected to login screen


# DIV08RPCPF-332
  Scenario: Verify that application trims leading/ trailing spaces and/or white-spaces between username when entered in the Username input field on forgot password screen
    Given I am on the Forgot Password page
	When I enter text " user name " which has leading/ trailing spaces and white-spaces in between in Username field on forgot password screen
	Then Application should trim those leading/ trailing spaces and white-spaces

# DIV08RPCPF-333
  Scenario: Verify that "Reset" button remains grayed-out/ inactive until username field is left blank
    Given I am on the Forgot Password page
	When I leave username field blank on forgot password screen
	Then "Reset" button should remain grayed-out/ inactive
	
# DIV08RPCPF-335
  Scenario: Verify that application throws error on entering username that doesn't exist in database
    Given I am on the Forgot Password page
	When I enter "unknownusername" in username field on forgot password screen
	And I click on the Reset button to reset password
	Then Application should throw an error "Please enter a valid username or email address." on forgot password screen

# DIV08RPCPF-336 --> Can't automate, feature not implemented yet
  @featureNotDevYet
  Scenario: Verify that application displays a success message mentioning next steps to complete password reset operation
    Given I am on the Forgot Password page
	When I enter "admin" in username field on forgot password screen
	And I click on the Reset button to reset password
	Then I should see a success message "Password reset link has been sent to registered email address."
	
# DIV08RPCPF-337
  Scenario: Verify that "Remember Me" is checked mark by default on login page
    Given I launch SAVP 4.0 web application
	When I land on the Login page
	Then Remember Me checkbox is checked by default	

# DIV08RPCPF-326 --> Can't automate, feature not implemented yet
  @featureNotDevYet
  Scenario: Verify that application auto-fills the previously entered username value on subsequent login attempts if "Remember Me" was checked during login
    Given I am on the Login page
	When Remember Me checkbox is checked by default
	And I login using valid username "self-reg-user" and password "S1cksick"
	And I logout from the application and navigate to login page
	Then The username field should be pre-populated with previously entered username value
	
# DIV08RPCPF-338
  Scenario: Verify that application trims leading/ trailing spaces and/or white-spaces between username when entered in the Username input field on self-registration screen
    Given I am on the Sign Up page
	When I enter text " user name " which has leading/ trailing spaces and white-spaces in between in Username field on self-registration screen
	Then Application should trim those leading/ trailing spaces and white-spaces	
	
# DIV08RPCPF-339
  Scenario: Verify that application navigates user back to login screen on clicking "Cancel" link on self-registration screen
    Given I am on the Login page
	When I click on the "Sign Up" link on login page
	And I click on the "cancel" link on forgot password screen	
	Then I should be redirected to login screen
	
# DIV08RPCPF-340, DIV08RPCPF-341
  Scenario: Verify that application displays "Password tips" link, clicking which pops-up a modal window outlining password complexity requirements and clicking OK button in it closes the modal
    Given I am on the Sign Up page
	When I click on the "Password tips" link on self-registration screen
	Then Application pop-ups a modal window outlining password complexity requirements
	When I click on OK button in the password complexity modal window
	Then Application closes the modal window

# DIV08RPCPF-342
  Scenario: Verify that "Create Account" button remains grayed-out/ inactive if any field(s) are left blank or if there are field validation errors
    Given I am on the Sign Up page
	When I leave username, password and repeat password fields blank
	Then "Create Account" button should remain grayed-out/ inactive
	When I enter "admin" in username field but leave password and repeat password fields blank
	Then "Create Account" button should remain grayed-out/ inactive
	When I enter "S1cksick" in password field but leave repeat password field blank
	Then "Create Account" button should remain grayed-out/ inactive
	When I enter "S1cksick" in repeat password field but leave password field blank
	Then "Create Account" button should remain grayed-out/ inactive
	When I enter "S1cksick" in password field and "S!cksick" in repeat password field
	Then "Create Account" button should remain grayed-out/ inactive
	When I enter "sicksick" in password field and "sicksick" in repeat password field
	Then "Create Account" button should remain grayed-out/ inactive

# DIV08RPCPF-343
  Scenario: Verify that application throws an error if value entered in "Password" and "Repeat Password" fields does not match
    Given I am on the Sign Up page
	When I enter "admin" in username field, "S1cksick" in password field and "S!cksick" in repeat password field
	Then Application should throw an error "Passwords do not match." on self-registration screen

# DIV08RPCPF-344
  Scenario: Verify that application throws an error if value entered in "Password" field does not meet complexity requirements
    Given I am on the Sign Up page
	When I enter "admin" in username field, "sicksick" in password field and "sicksick" in repeat password field
	Then Application should throw an error "Please enter a valid password." on self-registration screen

# DIV08RPCPF-345
  Scenario: Verify that application redirects user to login screen upon successful registration of a new user
    Given I am on the Sign Up page
	When I enter "self-reg-user" in username field, "S1cksick" in password field and "S1cksick" in repeat password field
	And I click on the Create Account button to self-register
	Then I should be redirected to login screen

# DIV08RPCPF-346 --> Can't automate, feature not implemented yet
  @featureNotDevYet
  Scenario: Verify that application displays a success message on login screen upon redirection from Sign Up page after successful registration of a new user
    Given I am on the Sign Up page
	When I enter "self-reg-user2" in username field, "S1cksick" in password field and "S1cksick" in repeat password field
	And I click on the Create Account button to self-register
	Then I should be redirected to login screen
	And I should see a success message "Congratulations! your new account has been registered successfully."
	
# DIV08RPCPF-347 --> Can't automate, feature not implemented yet
  @featureNotDevYet
  Scenario: Verify that application throws an error if username entered by user already exists in database
    Given I am on the Sign Up page
	When I enter an existing username "self-reg-user" in username field
	Then Application should throw an error "Username already exists in database." on self-registration screen
	
# DIV08RPCPF-348
  Scenario: Verify that application allows user to logout from the application
    Given I am on the Login page
	When I login using valid username "self-reg-user" and password "S1cksick"
	And I click on My Account button and further click on "Logout" link to logout from the application
	Then I should be redirected to Logout page with a button to navigate to Login page

# DIV08RPCPF-349 --> Can't automate, failing due to bug - DIV08RPCPF-350
  @fail
  Scenario: Verify that on clicking login button on Logout page application redirects user to Login page
    Given I am on the Login page
	When I login using valid username "self-reg-user" and password "S1cksick" and then logout
	When I click on the Login button on Logout page
	Then I should be redirected to login screen
	
  Scenario: Print test configuration & close the browser
	
	Then I print configuration
	Then I close browser