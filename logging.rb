# Utility function to create a directory
def create_dir(target)
  FileUtils.mkpath(target)
end

# Utility function to delete old log files
def delete_old_logs(target)
  Dir.glob(File.join(target, "*.log")).each do |file| 
    File.delete(file) if (Time.now - File.ctime(file))/(24*3600) > LOGGING_DAYS 
  end
end

# Initialize logger
create_dir(LOG_DIR)
delete_old_logs(LOG_DIR)
$logger = Logger.new("#{LOG_DIR}/run_#{Time.now.strftime("%Y-%m-%d--%H-%M-%S")}.log")
$logger.formatter = proc do |severity, datetime, progname, msg|
   "[#{datetime}]:#{severity}::#{msg}"
end

# Logs info messages
def loginfo(message)
  print message
  $logger.info(message)
end

# Logs warning messages
def logwarn(message)
  print message
  $logger.warn(message)
end 

# Logs error messages
def logerror(message)
  print message
  $logger.error(message)
end 