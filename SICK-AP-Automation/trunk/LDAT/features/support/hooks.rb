require_relative '../step_definitions/methods/push_sims.rb'

# Cucumber provides a number of hooks which allow us to run blocks at various points in the Cucumber test cycle
# Read about Cucumber hooks here - https://github.com/cucumber/cucumber/wiki/Hooks

# following hook will push only Objectdata
Before('@ObjSim', '~@ImgSim') do
  # This will only run before scenarios tagged
  # with @ObjSim.
  scenario_yaml_for_hook = "features/support/methods/yamls/hook_sims_config.yaml"
  $push_systemdata_from_hook = PushSims.new # Object of class defined in sims_hook_method.rb
  $sim_paths_in_hook = YAML.load_file(scenario_yaml_for_hook) # scenario_yaml_for_hook will push a particular data set every time

	$push_systemdata_from_hook.setup("#{$sim_paths_in_hook['systemdata_sim']['SOSA_simulator_path']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_input_xml_path']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_params']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_log_file_path']}")
end

# following hook will kill the process for only Objectdata when all the data is pushed
After('@ObjSim', '~@ImgSim') do
  # This will only run after scenarios tagged
  # with @ObjSim.
  $push_systemdata_from_hook.teardown("#{$sim_paths_in_hook['systemdata_sim']['systemdata_log_file_path']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_log_closing_statement']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_connection_error_statement']}")
end

# following hook will push only Imagedata
Before('~@ObjSim', '@ImgSim') do
  # This will only run before scenarios tagged
  # with @ImgSim.
	$push_imagedata_from_hook = PushSims.new # Object of class defined in sims_hook_method.rb
	$sim_paths_in_hook = YAML.load_file($scenario_yaml) # $scenario_yaml can be defined through the feature file

	$push_imagedata_from_hook.setup("#{$sim_paths_in_hook['imagedata_sim']['FTP_simulator_path']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_input_xml_path']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_params']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_log_file_path']}")
end

# following hook will kill the process for only Imagedata when all the data is pushed
After('~@ObjSim', '@ImgSim') do
  # This will only run after scenarios tagged
  # with @ImgSim.
  $push_imagedata_from_hook.teardown("#{$sim_paths_in_hook['imagedata_sim']['imagedata_log_file_path']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_log_closing_statement']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_connection_error_statement']}")
end

# following hook will push both Objectdata & Imagedata
Before('@ObjSim', '@ImgSim') do
  # This will only run before scenarios tagged
  # with @ObjSim AND @ImgSim.

	$push_systemdata_from_hook = PushSims.new # Object of class defined in sims_hook_method.rb
	$push_imagedata_from_hook = PushSims.new # Object of class defined in sims_hook_method.rb
	$sim_paths_in_hook = YAML.load_file($scenario_yaml) # $scenario_yaml can be defined through the feature file

	$push_systemdata_from_hook.setup("#{$sim_paths_in_hook['systemdata_sim']['SOSA_simulator_path']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_input_xml_path']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_params']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_log_file_path']}")

	$push_imagedata_from_hook.setup("#{$sim_paths_in_hook['imagedata_sim']['FTP_simulator_path']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_input_xml_path']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_params']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_log_file_path']}")
end

# following hook will kill the processes for both Objectdata & Imagedata when all the data is pushed
After('@ObjSim', '@ImgSim') do
  # This will only run after scenarios tagged
  # with @ObjSim AND @ImgSim.
  $push_systemdata_from_hook.teardown("#{$sim_paths_in_hook['systemdata_sim']['systemdata_log_file_path']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_log_closing_statement']}","#{$sim_paths_in_hook['systemdata_sim']['systemdata_connection_error_statement']}")

  $push_imagedata_from_hook.teardown("#{$sim_paths_in_hook['imagedata_sim']['imagedata_log_file_path']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_log_closing_statement']}","#{$sim_paths_in_hook['imagedata_sim']['imagedata_connection_error_statement']}")
end