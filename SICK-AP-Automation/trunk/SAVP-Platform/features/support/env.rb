require 'rubygems'
require 'selenium-cucumber'

require_relative 'browserstack_parameters_error_handling_methods'

# Store command line arguments for local execution
$browser_type = ENV['BROWSER'] || 'ff'
$platform = ENV['PLATFORM'] || 'desktop'
#$os_version = ENV['OS_VERSION']
$device_name = ENV['DEVICE_NAME']
$udid = ENV['UDID']
$app_path = ENV['APP_PATH']

# Store command line arguments for remote execution via Selenium Grid
$grid_platform = ENV['SELENIUM_PLATFORM'] || 'ANY'
$grid_browser_type = ENV['SELENIUM_BROWSER'] || 'firefox'
$grid_version = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']

# Store command line arguments for remote execution on Browserstack.com
$remote_execution = ENV['REMOTE_EXECUTION'] || 'no'
$browserstack_browser_type = ENV['REMOTE_BROWSER'] || 'Firefox'
$browser_version_num = ENV['BROWSER_VERSION'] || '44.0'
$os = ENV['OS_TYPE'] || 'Windows'
$os_version = ENV['OS_VERSION'] || '7'
$resolution = ENV['RESOLUTION'] || '1024x768'

# Store command line arguments specifically for defining IP Address & port of SAVP instance to undergo testing.
$savp_instance_ip_address = ENV['IP'] || '10.102.11.224' #If not defined, by default test will be executed over 10.102.11.224 instance
$savp_instance_port_number = ENV['PORT'] || '8080' #If not defined, by default port 8080 will be used

# check for valid parameters required for local execution
validate_parameters $platform, $browser_type, $app_path

# If platform is android or ios create driver instance for mobile browser
if $platform == 'android' or $platform == 'iOS' and $remote_execution == 'no'
  puts "Executing tests in local physical/simulator mobile device"
  if $browser_type == 'native'
    $browser_type = "Browser"
  end

  if $platform == 'android'
    $device_name, $os_version = get_device_info
  end

  desired_caps = {
    caps:       {
      platformName:  $platform,
      browserName: $browser_type,
      versionNumber: $os_version,
      deviceName: $device_name,
      udid: $udid,
      app: ".//#{$app_path}"
      },
    }

  begin
    $driver = Appium::Driver.new(desired_caps).start_driver
  rescue Exception => e
    puts e.message
    Process.exit(0)
  end
elsif $platform == 'browserstack' and $remote_execution == 'yes' # else create driver instance for remote browser on browserstack.com
validate_browserstack_parameters $os, $os_version, $browserstack_browser_type, $browser_version_num # check for valid parameters required for remote execution on browserstack.com if remote_execution is answered yes
puts "Executing tests on remote browser via Browserstack.com"
  begin
	# Input capabilities
	caps = Selenium::WebDriver::Remote::Capabilities.new
	caps["browser"] = $browserstack_browser_type
	caps["browser_version"] = $browser_version_num
	caps["os"] = $os
	caps["os_version"] = $os_version
	caps["resolution"] = $resolution
	caps["browserstack.debug"] = "true"
	caps["name"] = "Executing SAVP scripts over Browserstack.com"

    $driver = Selenium::WebDriver.for(:remote,
				:url => "http://<username>:<token>@hub.browserstack.com/wd/hub", # enter the url from browserstack with token
				:desired_capabilities => caps)
    $driver.manage().window().maximize()
  rescue Exception => e
    puts e.message
    Process.exit(0)
  end
elsif $platform == 'desktop' and $remote_execution == 'yes' # else create driver instance for remote browser via selenium grid
puts "Executing tests on remote browser via Selenium Grid"
  begin
	# Input capabilities
	capabilities = Selenium::WebDriver::Remote::Capabilities.new

	capabilities['platform'] = $grid_platform
	capabilities['name'] = "Executing SAVP scripts over Selenium Grid"
	capabilities['browserName'] = $grid_browser_type
	capabilities['version'] = $grid_version

    $driver = Selenium::WebDriver.for(:remote,
				:url => "http://10.102.11.224:4444/wd/hub", # enter the IP address/ FQDN of selenium grid hub
				:desired_capabilities => capabilities)
#				:desired_capabilities => 'firefox')
#				:desired_capabilities => "#{$grid_browser_type}")
    $driver.manage().window().maximize()
  rescue Exception => e
    puts e.message
    Process.exit(0)
  end
elsif $platform == 'desktop' and $remote_execution == 'no' # else create driver instance for desktop browser
  puts "Executing tests in local machine"
  begin
    $driver = Selenium::WebDriver.for(:"#{$browser_type}")
    $driver.manage().window().maximize()
  rescue Exception => e
    puts e.message
    Process.exit(0)
  end
else # else ask user to provide valid value for platform and remote_execution
  puts "\nOops... Invalid answer for either PLATFORM or REMOTE_EXECUTION"
  puts "\nSupported answers for PLATFORM are \"desktop\" or \"android\" or \"ios\" or \"browserstack\" and for REMOTE_EXECUTION are \"yes\" or \"no\"."
  puts "\nTo run on browserstack.com or selenium grid you need to specify PLATFORM as \"browserstack\" or \"desktop\" respectively and REMOTE_EXECUTION as \"yes\" else no need to mention PLATFORM or REMOTE_EXECUTION for local desktop execution."
  Process.exit(0)
end
