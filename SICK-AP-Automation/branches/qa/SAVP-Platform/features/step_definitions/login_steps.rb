require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'
require 'yaml'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

Given(/^I launch SAVP 4.0 web application$/) do
  step %[I navigate to "#{$SAVP_Login_URL}"]
end

Then(/^I land on (.+)$/) do |screen_name|
  step %[I wait for 1 sec]
  if screen_name == "the home page of SAVP dashboard"
	step %[element having #{$myAccount.type} "#{$myAccount.value}" should be present]
  elsif screen_name == "the Login page"
	step %[element having #{$loginUsername.type} "#{$loginUsername.value}" should be present]
  elsif screen_name == "forgot password screen"
	step %[element having #{$forgotPasswordUsername.type} "#{$forgotPasswordUsername.value}" should be present]
  elsif screen_name == "self-registration screen"
	step %[element having #{$signUpUsername.type} "#{$signUpUsername.value}" should be present]
  else
  	puts "Please recheck step. Only \"the home page of SAVP dashboard\", \"the Login page\", \"forgot password screen\" & \"self\-registration screen\" can be used as valid page or screen name in this step."
	  raise TestCaseFailed, 'Incorrect page or screen name specified in Step'
  end
end

Then(/^I should see SICK logo with text "([^"]*)" below it$/) do |tagline|
  step %[actual image having #{$signUpUsername.type} "#{$signUpUsername.value}" and expected image having image_name "SICK_logo.png" should be similar]
  step %[element having #{$taglineBelowLogo.type} "#{$taglineBelowLogo.value}" should have text as "#{tagline}"]
end

Then(/^I should see (.+) (.+) on login page$/) do |field_name, field_type|
  step %[I wait for 1 sec]
  if field_type == "input field"
	  if field_name == "Username"
		step %[element having #{$loginUsername.type} "#{$loginUsername.value}" should be present]
	  elsif field_name == "Password"
		step %[element having #{$loginPassword.type} "#{$loginPassword.value}" should be present]
	  else
		puts "Please recheck step. Only \"Username\" & \"Password\" can be used as valid input field names in this step."
		raise TestCaseFailed, 'Incorrect input field name specified in Step'
	  end
  elsif field_type == "button"
	  if field_name == "Sign In"
		step %[element having #{$signIn.type} "#{$signIn.value}" should be present]
	  else
		puts "Please recheck step. Only \"Sign In\" can be used as valid button name in this step."
		raise TestCaseFailed, 'Incorrect button name specified in Step'
	  end
  elsif field_type == "checkbox"
	  if field_name == "Remember Me"
		step %[checkbox having #{$rememberMe.type} "#{$rememberMe.value}" should be checked]
	  else
		puts "Please recheck step. Only \"Remember Me\" can be used as valid checkbox name in this step."
		raise TestCaseFailed, 'Incorrect checkbox name specified in Step'
	  end
  elsif field_type == "link"
	  if field_name == "Forgot Password?" || field_name == "Sign Up"
		step %[link having text "#{field_name}" should be present]
	  else
		puts "Please recheck step. Only \"Forgot Password?\" & \"Sign Up\" can be used as valid link names in this step."
		raise TestCaseFailed, 'Incorrect link name specified in Step'
	  end
  else
	puts "Please recheck step. Only \"input field\", \"button\", \"checkbox\" & \"link\" can be used as valid field types in this step."
	raise TestCaseFailed, 'Incorrect field type specified in Step'
  end
end

# temp logic - improve after bug fix
Given(/^I am on the (.+) page$/) do |page_name|
  if page_name == "Login"
	step %[I navigate to "#{$SAVP_Login_URL}"]
  elsif page_name == "Forgot Password"
	#step %[I navigate to "#{$SAVP_Forgot_Password_URL}"]
	step %[I navigate to "#{$SAVP_Login_URL}"]
	step %[I wait for 1 sec]
    step %[I click on link having text "#{page_name}"]
  elsif page_name == "Sign Up"
	#step %[I navigate to "#{$SAVP_Sign_Up_URL}"]
	step %[I navigate to "#{$SAVP_Login_URL}"]
	step %[I wait for 1 sec]
    step %[I click on link having text "#{page_name}"]
  else
  	puts "Please recheck step. Only \"Login\", \"Forgot Password\" & \"Sign Up\" can be used as valid page names in this step."
	raise TestCaseFailed, 'Incorrect page name specified in Step'
  end
end

When(/^I enter text "([^"]*)" which has leading\/ trailing spaces and white\-spaces in between in Username field on (.+)$/) do |username_with_spaces, screen_name|
  step %[I wait for 1 sec]
  if screen_name == "login screen"
	step %[I enter "#{username_with_spaces}" into input field having #{$loginUsername.type} "#{$loginUsername.value}"]
  elsif screen_name == "forgot password screen"
	step %[I enter "#{username_with_spaces}" into input field having #{$forgotPasswordUsername.type} "#{$forgotPasswordUsername.value}"]
  elsif screen_name == "self-registration screen"
	step %[I enter "#{username_with_spaces}" into input field having #{$signUpUsername.type} "#{$signUpUsername.value}"]
  else
  	puts "Please recheck step. Only \"login screen\", \"forgot password screen\" & \"self\-registration screen\" can be used as valid page or screen name in this step."
	raise TestCaseFailed, 'Incorrect page or screen name specified in Step'
  end
end

Then(/^Application should trim those leading\/ trailing spaces & white spaces and make username value "([^"]*)"$/) do |trimmed_username|
  step %[element having #{$loginUsername.type} "#{$loginUsername.value}" should have text as "#{trimmed_username}"]
end

When(/^I leave username field blank$/) do
  step %[I clear input field having #{$loginUsername.type} "#{$loginUsername.value}"]
end

When(/^I leave username and password fields blank$/) do
  step %[I clear input field having #{$loginUsername.type} "#{$loginUsername.value}"]
  step %[I clear input field having #{$loginPassword.type} "#{$loginPassworde.value}"]
end

Then(/^"([^"]*)" button should remain grayed\-out\/ inactive$/) do |button_name|
  step %[element having #{$signIn.type} "#{$signIn.value}" should be disabled]
end

When(/^I enter "([^"]*)" in (.+) field but leave (.+) field blank$/) do |field_value, field1_name, field2_name|
  step %[I wait for 1 sec]
  if field1_name == "username" && field2_name == "password"
	step %[I enter "#{field_value}" into input field having #{$loginUsername.type} "#{$loginUsername.value}"]
	step %[I clear input field having #{$loginPassword.type} "#{$loginPassword.value}"]
  elsif field1_name == "password" && field2_name == "username"
	step %[I enter "#{field_value}" into input field having #{$loginPassword.type} "#{$loginPassword.value}"]
	step %[I clear input field having #{$loginUsername.type} "#{$loginUsername.value}"]
  elsif field1_name == "password" && field2_name == "repeat password"
	step %[I enter "#{field_value}" into input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
	step %[I clear input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
  elsif field1_name == "repeat password" && field2_name == "password"
	step %[I enter "#{field_value}" into input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
	step %[I clear input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
  else
  	puts "Please recheck step. Only \"username\" & \"password\" can be used as valid field names in this step."
	raise TestCaseFailed, 'Incorrect field name specified in Step'
  end
end

When(/^I enter "([^"]*)" in (.+) field on (.+)$/) do |field_value, field_name, screen_name|
  step %[I wait for 1 sec]
  if screen_name == "login screen"
	  if field_name == "username"
		step %[I enter "#{field_value}" into input field having #{$loginUsername.type} "#{$loginUsername.value}"]
	  elsif field_name == "password"
		step %[I enter "#{field_value}" into input field having #{$loginPassword.type} "#{$loginPassword.value}"]
	  else
		puts "Please recheck step. Only \"username\" & \"password\" can be used as valid field names in this step."
		raise TestCaseFailed, 'Incorrect field name specified in Step'
	  end
  elsif screen_name == "forgot password screen"
	  if field_name == "username"
		step %[I enter "#{field_value}" into input field having #{$forgotPasswordUsername.type} "#{$forgotPasswordUsername.value}"]
	  else
		puts "Please recheck step. Only \"username\" can be used as valid field name for forgot password screen in this step."
		raise TestCaseFailed, 'Incorrect field name specified in Step'
	  end
  elsif screen_name == "self-registration screen"
	  if field_name == "username"
		step %[I enter "#{field_value}" into input field having #{$signUpUsername.type} "#{$signUpUsername.value}"]
	  elsif field_name == "password"
		step %[I enter "#{field_value}" into input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
	  elsif field_name == "repeat password"
		step %[I enter "#{field_value}" into input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
	  else
		puts "Please recheck step. Only \"username\", \"password\" & \"repeat password\" can be used as valid field names in this step."
		raise TestCaseFailed, 'Incorrect field name specified in Step'
	  end
  else
  	puts "Please recheck step. Only \"login screen\", \"forgot password screen\" & \"self\-registration screen\" can be used as valid page or screen name in this step."
	raise TestCaseFailed, 'Incorrect page or screen name specified in Step'
  end
end

When(/^I click on the (.+) button to (.+)$/) do |button_name, action_type|
  step %[I wait for 1 sec]
  if button_name == "Sign In" && action_type == "login"
	step %[I click on element having #{$signIn.type} "#{$signIn.value}"]
  elsif button_name == "Reset" && action_type == "reset password"
	step %[I click on element having #{$reset.type} "#{$reset.value}"]
  elsif button_name == "Create Account" && action_type == "self-register"
	step %[I click on element having #{$createAccount.type} "#{$createAccount.value}"]
  else
  	puts "Please recheck step. Only \"Sign In\", \"Reset\" & \"Create Account\" as valid button names and \"login\", \"reset password\" & \"self\-register\" as valid action types can be used in this step."
	raise TestCaseFailed, 'Incorrect button name or action type specified in Step'
  end
end

Then(/^Application should throw an error "([^"]*)" on (.+)$/) do |error_text, screen_name|
  step %[I wait for 1 sec]
  if screen_name == "login page"
	  if error_text.downcase.include? "Username or password".downcase
		step %[element having #{$incorrectUsernameOrPasswordError.type} "#{$incorrectUsernameOrPasswordError.value}" should have text as "#{error_text}"]
	  else
		puts "Please recheck error text specified in the step."
		raise TestCaseFailed, 'Incorrect error text specified in Step'
	  end
  elsif screen_name == "forgot password screen"
	  if error_text.downcase.include? "enter a valid username or email".downcase
		step %[element having #{$invalidUsernameForgotPasswordError.type} "#{$invalidUsernameForgotPasswordError.value}" should have text as "#{error_text}"]
	  else
		puts "Please recheck error text specified in the step."
		raise TestCaseFailed, 'Incorrect error text specified in Step'
	  end
  elsif screen_name == "self-registration screen"
	  if error_text.downcase.include? "Passwords do not match".downcase
		step %[element having #{$passwordMismatchSignUpError.type} "#{$passwordMismatchSignUpError.value}" should have text as "#{error_text}"]
	  elsif error_text.downcase.include? "enter a valid password".downcase
		step %[element having #{$invalidPasswordSignUpError.type} "#{$invalidPasswordSignUpError.value}" should have text as "#{error_text}"]
	  elsif error_text.downcase.include? "Username already exists".downcase
		step %[element having #{$invalidUsernameSignUpError.type} "#{$invalidUsernameSignUpError.value}" should have text as "#{error_text}"]
	  else
		puts "Please recheck error text specified in the step."
		raise TestCaseFailed, 'Incorrect error text specified in Step'
	  end
  else
  	puts "Please recheck step. Only \"login page\", \"forgot password screen\" & \"self\-registration screen\" can be used as valid screens in this step."
	raise TestCaseFailed, 'Incorrect screen name specified in Step'
  end
end

When(/^I click on the "([^"]*)" link on (.+)$/) do |link_text, screen_name|
  step %[I wait for 1 sec]
  if screen_name == "login page"
	step %[I click on link having text "#{link_text}"]
  elsif screen_name == "forgot password screen"
	step %[I click on link having text "#{link_text}"]
  elsif screen_name == "self-registration screen"
	step %[I click on link having text "#{link_text}"]
  else
  	puts "Please recheck step. Only \"login page\", \"forgot password screen\" & \"self\-registration screen\" can be used as valid screens in this step."
	raise TestCaseFailed, 'Incorrect screen name specified in Step'
  end
end

Then(/^I should be redirected to login screen$/) do
  step %[I wait for 1 sec]
  step %[element having #{$loginUsername.type} "#{$loginUsername.value}" should be present]
end

Then(/^I should see a success message "([^"]*)"$/) do |arg1|
  step %[element having #{$signUpSuccessMessage.type} "#{$signUpSuccessMessage.value}" should have text as "#{error_text}"]
end

Then(/^Remember Me checkbox is checked by default$/) do
  step %[checkbox having #{$rememberMe.type} "#{$rememberMe.value}" should be checked]
end

When(/^I login using valid username "([^"]*)" and password "([^"]*)"$/) do |username_value, password_value|
  step %[I enter "#{username_value}" in username field on login screen]
  step %[I enter "#{password_value}" in password field on login screen]
  step %[I click on the Sign In button to login]
  step %[I wait for 1 sec]
end

When(/^I logout from the application and navigate to login page$/) do
  step %[I click on element having #{$myAccount.type} "#{$myAccount.value}"]
  step %[I click on link having text "#{logout_link}"]
  step %[I wait 1 seconds for element having #{$loginOnLogout.type} "#{$loginOnLogout.value}" to display]
  step %[I click on element having #{$loginOnLogout.type} "#{$loginOnLogout.value}"]
  step %[I wait 1 seconds for element having #{$loginUsername.type} "#{$loginUsername.value}" to display]
end

Then(/^The username field should be pre\-populated with previously entered username value$/) do
  step %[element having #{$invalidUsernameSignUpError.type} "#{$invalidUsernameSignUpError.value}" should have text as "#{$usernameForRememberMeValidation}"]
end

Then(/^Application pop\-ups a modal window outlining password complexity requirements$/) do
  step %[I wait 1 seconds for element having #{$passwordTipsModalHeader.type} "#{$passwordTipsModalHeader.value}" to display]
  step %[element having #{$passwordTipsModalComplexityReq1.type} "#{$passwordTipsModalComplexityReq1.value}" should have text as "Minimum of 8 characters in length"]
  step %[element having #{$passwordTipsModalComplexityReq2.type} "#{$passwordTipsModalComplexityReq2.value}" should have text as "Must contain at least one number (0-9)"]
  step %[element having #{$passwordTipsModalComplexityReq3.type} "#{$passwordTipsModalComplexityReq3.value}" should have text as "Must contain at least one uppercase letter (A-Z)"]
end

When(/^I click on OK button in the password complexity modal window$/) do
  step %[I click on element having #{$passwordTipsOKButton.type} "#{$passwordTipsOKButton.value}"]
end

Then(/^Application closes the modal window$/) do
  step %[I wait for 1 sec]
  step %[element having #{$passwordTipsModalHeader.type} "#{$passwordTipsModalHeader.value}" should not be present]
end

When(/^I leave username, password and repeat password fields blank$/) do
  step %[I clear input field having #{$signUpUsername.type} "#{$signUpUsername.value}"]
  step %[I clear input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
  step %[I clear input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
end

When(/^I enter "([^"]*)" in username field but leave password and repeat password fields blank$/) do |username_value|
  step %[I enter "#{username_value}" into input field having #{$signUpUsername.type} "#{$signUpUsername.value}"]
  step %[I clear input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
  step %[I clear input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
end

When(/^I enter "([^"]*)" in password field and "([^"]*)" in repeat password field$/) do |password_value, confirm_password_value|
  step %[I enter "#{password_value}" into input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
  step %[I enter "#{confirm_password_value}" into input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
end

When(/^I enter "([^"]*)" in username field, "([^"]*)" in password field and "([^"]*)" in repeat password field$/) do |username_value, password_value, confirm_password_value|
  step %[I enter "#{username_value}" into input field having #{$signUpUsername.type} "#{$signUpUsername.value}"]
  step %[I enter "#{password_value}" into input field having #{$signUpPassword.type} "#{$signUpPassword.value}"]
  step %[I enter "#{confirm_password_value}" into input field having #{$signUpRepeatPassword.type} "#{$signUpRepeatPassword.value}"]
end

When(/^I enter an existing username "([^"]*)" in username field$/) do |existing_username_value|
  step %[I enter "#{existing_username_value}" into input field having #{$signUpUsername.type} "#{$signUpUsername.value}"]
end

When(/^I click on My Account button and further click on "([^"]*)" link to logout from the application$/) do |logout_link|
  step %[I click on element having #{$myAccount.type} "#{$myAccount.value}"]
  step %[I click on link having text "#{logout_link}"]
end

Then(/^I should be redirected to Logout page with a button to navigate to Login page$/) do
  step %[element having #{$loginOnLogout.type} "#{$loginOnLogout.value}" should be present]
end

When(/^I login using valid username "([^"]*)" and password "([^"]*)" and then logout$/) do |username_value, password_value|
  $usernameForRememberMeValidation = username_value
  step %[I enter "#{username_value}" in username field on login screen]
  step %[I enter "#{password_value}" in password field on login screen]
  step %[I click on the Sign In button to login]
  step %[I wait for 3 sec]
  step %[I click on element having #{$myAccount.type} "#{$myAccount.value}"]
  step %[I click on link having text "#{logout_link}"]
end

When(/^I click on the Login button on Logout page$/) do
  step %[I click on element having #{$loginOnLogout.type} "#{$loginOnLogout.value}"]
end