require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'
require_relative 'property_master.rb'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

# **-> URL of SAVP instance for which the automation scripts will be executed <-**

# ************-> DEFINE SAVP 4.0 QA INSTANCE URL <-************ #
# IP Address and Port number values can be passed via command line using parameters "IP" and "PORT"
# If IP and PORT values are not passed via command line, by default IP Address: 10.102.11.224 and Port: 8080 will be used

$SAVP_Login_URL = "http://#{$savp_instance_ip_address}:#{$savp_instance_port_number}/" #auth/login

$SAVP_Forgot_Password_URL = "http://#{$savp_instance_ip_address}:#{$savp_instance_port_number}/auth/recover"

$SAVP_Sign_Up_URL = "http://#{$savp_instance_ip_address}:#{$savp_instance_port_number}/auth/create"

$SAVP_Overview_Dashboard_URL = "http://#{$savp_instance_ip_address}:#{$savp_instance_port_number}/"

# ------------------------------------------------------------- #


# **-> Locators for Global Web Elements of Login page <-**

# SICK logo on Login page
$SICKlogo = WebElement.new("xpath", ".//*[@id='root']/div/div/div[1]/p[1]/img")

# Tag line below logo on Login page
$taglineBelowLogo = WebElement.new("xpath", ".//*[@id='root']/div/div/div[1]/p[2]")

# Welcome message on Login page
$loginMessage = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[1]/div[1]/small")

# Username field on Login page
$loginUsername = WebElement.new("id", "undefined--UsernameorEmailaddress-58234")

# Password field on Login page
$loginPassword = WebElement.new("id", "undefined-Password-Password-36752")

# Remeber Me checkbox on Login page
$rememberMe = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[2]/div[1]/div/div/input")

# Sign In button on Login page
$signIn = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[3]/div/button")

# Incorrect username or password error on Login page
$incorrectUsernameOrPasswordError = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[1]/div[3]/div[2]/p")



# **-> Locators for Global Web Elements of Forgot Password page <-**

# Username field on Forgot Password page
$forgotPasswordUsername = WebElement.new("id", "undefined-UsernameorEmailaddress-UsernameorEmailaddress-21493")

# Reset button on Forgot Password page
$reset = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[2]/div/div[2]/div/div/button")

# Invalid username error on Forgot Password page
$invalidUsernameForgotPasswordError = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[1]/div[2]/div[3]/p")



# **-> Locators for Global Web Elements of Sign Up page <-**

# Welcome message on Sign Up page
$signupMessage = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[3]/p")

# Username field on Sign Up page
$signUpUsername = WebElement.new("id", "undefined-UsernameorEmailaddress-UsernameorEmailaddress-57201")

# Password field on Sign Up page
$signUpPassword = WebElement.new("id", "undefined-Password-Password-31008")

# Repeat Password field on Sign Up page
$signUpRepeatPassword = WebElement.new("id", "undefined-RepeatPassword-RepeatPassword-47436")

# Create Account button on Sign Up page
$createAccount = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[2]/div/div[2]/div/div/button")

# Invalid username error on Sign Up page
$invalidUsernameSignUpError = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[1]/div[2]/div[3]/p")

# Invalid password error on Sign Up page
$invalidPasswordSignUpError = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[1]/div[3]/div[3]/p")

# Mismatch password error on Sign Up page
$passwordMismatchSignUpError = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div[1]/div[5]/div[3]/p")

# Header text of Password tips modal outlining password complexity requirements
$passwordTipsModalHeader = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/h3")

# Password complexity requirement number 1
$passwordTipsModalComplexityReq1 = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[1]/ul/li[1]")

# Password complexity requirement number 2
$passwordTipsModalComplexityReq2 = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[1]/ul/li[2]")

# Password complexity requirement number 3
$passwordTipsModalComplexityReq3 = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[1]/ul/li[3]")

# OK buttun in Password tips modal
$passwordTipsOKButton = WebElement.new("xpath", "html/body/div[2]/div/div[1]/div/div/div[2]/button")

# Success message on Login page after successful registration
$signUpSuccessMessage = WebElement.new("xpath", "")

# **-> Locators for Global Web Elements of Logout page <-**

# Message on Logout page
$logoutMessage = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div/p")

# Login button on Logout page
$loginOnLogout = WebElement.new("xpath", ".//*[@id='root']/div/div/div[2]/div/div/div/button")



# **-> Locators for Global Web Elements of Home page <-**

# My Account button on home page
$myAccount = WebElement.new("xpath", ".//*[@id='root']/div/div/div[1]/div/div[1]/div/div/div/button")

#or $myAccount = WebElement.new("css", "div.Header__logo___jyTn8 > div > div > div > button[type=\"button\"]")
