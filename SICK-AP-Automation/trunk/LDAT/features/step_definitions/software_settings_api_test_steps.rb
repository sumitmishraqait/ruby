require 'selenium-cucumber'
require 'cucumber-rest-bdd'
require 'cucumber-api'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

Given(/^I reset software settings of following server:$/) do |table|
  # convert table to a hash with each row as a key, value pair
  db_info = table.rows_hash

  # temporarily store & use ip address var for add conditions step until Cassandra starts supporting inserting an object in map of a map
  @server_ip_address = db_info['ip_address']

  # Object of class defined in query_cassandra.rb
  @sys_config = QueryCassandra.new

  # establish a connection with Cassandra DB
  @sys_config.setup(db_info['keyspace'],db_info['ip_address'])

  # define the truncate statement
  prepared_truncate_statement = 'TRUNCATE %{key}.%{table}' % {key: db_info['keyspace'], table: db_info['table']}

  # execute the truncate statement via remote cqlsh
  @sys_config.execute_statement(prepared_truncate_statement)

    # define the CQL statement to overwrite current software settings
  prepared_overwrite_statement = 'insert into %{key}.%{table}(facility_id,device_types,assigned_settings)values(\'01\',{ \'CLV\',\'LECTOR\', \'ICR\', \'MSC/SIM\', \'IPCam\', \'VMS\', \'Other\'},
  {\'userSettings\':{
      \'dateFormat\':{
        code:\'dateFormat\',
        value: \'DEFAULT\',
        action:{
          \'read\': true,
          \'update\': false,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'String\',
        accepted_values:{\'DEFAULT\'},
        validation:{}

      },
      \'timeFormat\':{
        code:\'timeFormat\',
        value: \'ISO_24_HOUR\',
        action:{
          \'read\': true,
          \'update\': true,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'String\',
        accepted_values:{\'ISO_12_HOUR\',\'ISO_24_HOUR\'},
        validation:{
        }

      },
      \'unitSystem\':{
        code:\'unitSystem\',
        value: \'METRIC\',
        action:{
          \'read\': true,
          \'update\': true,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'String\',
        accepted_values:{\'METRIC\',\'IMPERIAL_FEET\',\'IMPERIAL_INCHES\'},
        validation:{
        }
      }
    },

    \'databaseSettings\':{
      \'dataRetention\':{
        code:\'dataRetention\',
        value: \'90\',
        action:{
          \'read\': true,
          \'update\': true,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'Integer\',
        accepted_values:{},
        validation:{
          {
            code:\'min\',
            value:\'1\'
          },
          {
            code:\'max\',
            value:\'366\'
          }
        }
      },
      \'databaseUsage\':{
        code:\'databaseUsage\',
        value: NULL,
        action:{
          \'read\': true,
          \'update\': false,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'String\',
        accepted_values:{},
        validation:{
        }
      }
    },
    \'logFileSettings\':{
      \'logsRetention\':{
        code:\'logsRetention\',
        value: \'10\',
        action:{
          \'read\': true,
          \'update\': false,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'Integer\',
        accepted_values:{},
        validation:{
          {
            code:\'min\',
            value:\'1\'
          },
          {
            code:\'max\',
            value:\'30\'
          }
        }
      },
      \'logFileLocation\':{
        code:\'logFileLocation\',
        value: \'C:\SICK\Analytics\Scorpio\Logs\',
        action:{
          \'read\': true,
          \'update\': false,
          \'create\': false,
          \'delete\': false
        },
        data_type:\'String\',
        accepted_values:{},
        validation:{
        }
      }
    }
  }
);' % {key: db_info['keyspace'], table: db_info['table']}

  # execute the truncate statement via remote cqlsh
  @sys_config.execute_statement(prepared_overwrite_statement)
end

# wasn't able to utilize in the RESTful API feature but it can be reused in end to end automation test by reading the value from UI and then validating it's pattern
Then(/^the pattern of "([^"]*)" should match the desired pattern for database usage display$/) do |db_usage|
  puts db_usage
  pattern_matched = /\d*[,]?\d*[.]\d++ (MB|GB)\(\d*[,]?\d*[.]\d++\% of C\:drive\)/ === db_usage
  puts pattern_matched
  if !pattern_matched
    puts "Pattern returned by service doesn't match the desired pattern for database usage display"
    raise TestCaseFailed, 'Database usage display pattern match failure'
  end
end