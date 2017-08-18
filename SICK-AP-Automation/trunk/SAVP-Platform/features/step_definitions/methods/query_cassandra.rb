require 'rubygems'
require 'colorize'
require 'cassandra'

# Do Not Remove This File
# This file contains assertion methods which are called from hooks.rb

class QueryCassandra
  def setup(keyspace_name, cassandra_ip)
    cluster = Cassandra.cluster(
            username: "sick_ap_user",
            password: "s1ckSick",
            hosts: ["#{cassandra_ip}"]
          )
    cluster.each_host do |host| # automatically discovers all peers
      puts "Conected to Cassandra Host with IP: #{host.ip}, id=#{host.id}, datacenter=#{host.datacenter}, rack=#{host.rack}".green
    end
    @session  = cluster.connect(keyspace_name)
  end

# Create a custom function if it doesn't exist already that allows to make queries with timestamp as string to avoid timestamp formatting issues faced on converting the string to time data type
  def create_custom_function
    # puts "Creating a custom function to make queries with timestamp as a string...".cyan
    @session.execute('CREATE OR REPLACE FUNCTION timefstring(somearg text)
    RETURNS NULL ON NULL INPUT
    RETURNS timestamp
    LANGUAGE java
    AS $$
      java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      try {
        Date date = formatter.parse(somearg);
          return date;
      } catch(java.text.ParseException e) {
        return new Date();
      }
    $$')
  end

# Generic method to query Cassandra DB by a prepared statement with upto 5 arguments or simply query a statement without any arguments
  def query_statement(statement, *arguments)
    if arguments.length > 5
      raise ArgumentError, 'Too many arguments, prepared statement with only upto 5 arguments is supported for simplicity'
    elsif arguments.length == 0
      query_results = @session.execute("#{statement}")
    else
      prepared_statement = @session.prepare("#{statement}")
      query_results = @session.execute(prepared_statement, arguments: arguments)
    end
    return query_results
  end

# Generic method to query Cassandra DB by a prepared statement with upto 5 arguments or simply query a statement without any arguments
  def execute_statement(statement, *arguments)
    if arguments.length > 5
      raise ArgumentError, 'Too many arguments, prepared statement with only upto 5 arguments is supported for simplicity'
    elsif arguments.length == 0
      @session.execute("#{statement}")
    else
      prepared_statement = @session.prepare("#{statement}")
      @session.execute(prepared_statement, arguments: arguments)
    end
  end

  def teardown
    @session.close
  end
end