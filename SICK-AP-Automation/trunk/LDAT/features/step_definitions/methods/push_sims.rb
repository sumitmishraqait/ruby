require 'rubygems'
require 'colorize'

# Do Not Remove This File
# This file contains assertion methods which are called from hooks.rb

class PushSims
  def setup(sim_type,input_xml,params,log_file)
    timestamp = Time.now
    to_run = 'start /b cmd.exe /c call java -jar "%{sim}" "%{xml}" %{param} > %{log}' % {sim: sim_type, xml: input_xml, param: params, log: log_file}
    @pid = Process.spawn(to_run)
    puts "Process for \"#{sim_type}\" simulator started with PID\: #{@pid} at ".cyan + "#{timestamp.inspect}".yellow
  end

  def watch_for(file,success,failure)
    kill = 0
    f = File.open(file,"r")
    # Since this file exists and is growing, seek to the end of the most recent entry
    sleep 0.01
    f.seek(0,IO::SEEK_CUR) #SEEK_END only works for SOSA
      while true do
        sleep 0.3
        select([f])
        line = f.gets
        if line=~success
          puts "Detected! in process logs - Closing statement: ".cyan + "\"#{line}\"".green
          kill = 1
          break
        elsif line=~failure
          puts "Detected! in process logs - Error statement: ".magenta + "\"#{line}\"".red
          kill = 2
          break
        end
      end
    return kill
  end

  def teardown(log_path,positive_pattern,negative_pattern)
    status = watch_for(log_path,/#{positive_pattern}/,/#{negative_pattern}/)
      if status == 1
        timestamp = Time.now
        puts "Killing completed process running with PID\: #{@pid} at ".cyan + "#{timestamp.inspect}".yellow
        Process.kill(0, @pid) if @pid
      elsif status == 2
        timestamp = Time.now
        puts "Killing failed process running with PID\: #{@pid} at ".magenta + "#{timestamp.inspect}".yellow
        Process.kill(0, @pid) if @pid
      else
        puts "Process with PID\: #{@pid} not running".red
      end
  end
end