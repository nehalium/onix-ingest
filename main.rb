# 
# ONIX INGEST 
# An application to pull ONIX files, parse and flatten them, 
# and insert the data into a database
# 
# Dependencies:
#   Ruby 1.9.3 (https://www.ruby-lang.org/en/downloads/)
#   Base-X (http://basex.org/)
#   MySQL (http://dev.mysql.com/downloads/)
#
# Gems:
#   rubyzip (https://github.com/rubyzip/rubyzip)
#   nokogiri (http://nokogiri.org/)
#   mysql (https://rubygems.org/gems/mysql) 
#
require './lib/BaseXClient.rb'
require 'fileutils'
require 'logger'
require 'zip' #gem install rubyzip
require 'nokogiri' #gem install nokogiri
require 'mysql' #gem install mysql

# Configuration
SOURCE_DIR = "C:/Users/nehals/Desktop/Nehal/ONIX/source"
TARGET_DIR = "C:/Users/nehals/Desktop/Nehal/ONIX/target"
ARCHIVE_DIR = "C:/Users/nehals/Desktop/Nehal/ONIX/archive"
LOG_DIR = "C:/Users/nehals/Desktop/Nehal/ONIX/log"
BASEX_HOST = "localhost"
BASEX_PORT = 1984
BASEX_USERNAME = "admin"
BASEX_PASSWORD = "admin"
MYSQL_HOST = "localhost"
MYSQL_USERNAME = "root"
MYSQL_PASSWORD = "root"
MYSQL_DATABASE = "onix" 

# Initialize logger
FileUtils.mkpath(LOG_DIR)
$logger = Logger.new("#{LOG_DIR}/run_#{Time.now.strftime("%m-%d-%Y--%H-%M-%S")}.log")
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

def import_to_database(record)
  names = Array.new
  values = Array.new
  record.xpath("/record/product/*").each do |node|
    if (node.xpath("@ignore").text != "true")
      names << node.name
      type = node.xpath("@type").text
      value = Mysql.escape_string(node.text)
      case type
        when "varchar", "char", "text"
          values << "'#{value}'"
        else
          values << (value != '')? value : "NULL"
      end
    end
  end
  names << "opened"
  values << "'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  names << "updated"
  values << "'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  
  loginfo("Inserting into DB...")
  sql = "INSERT INTO productmasterfile (#{names.join(',')}) VALUES (#{values.join(',')});"
  loginfo("\n#{sql}\n")
  db = Mysql.new(MYSQL_HOST, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE)
  db.query(sql)
  #st = db.prepare(sql)
  #st.execute(values)
  loginfo("Done.\n")
rescue Mysql::Error => e
  logerror("[MYSQL] #{e.errno}:#{e.error}\n")
ensure
  #st.close if st
  db.close if db
end

def process_record(record)
  import_to_database(Nokogiri::XML(record))
end

def process_records(session)
  loginfo("Processing...\n")
  query = session.query(File.read(File.join(Dir.pwd, "main.xq")))
  while query.more do
    process_record(query.next)
  end
  query.close()
  loginfo("Done.\n")
end

def print_records_in_aggregate(session)
  puts session.execute("RUN #{ROOT_DIR}\\basex\\test.xq")
end

def process(dir)
  session = BaseXClient::Session.new(BASEX_HOST, BASEX_PORT, BASEX_USERNAME, BASEX_PASSWORD)
  begin
    loginfo("Opening Base-X DB...")
    session.execute("CREATE DATABASE ONIX #{dir}")
    session.execute("OPEN ONIX")
    loginfo("Done.\n")
    process_records(session)
    loginfo("Closing Base-X DB...")
    session.execute("DROP DB ONIX")
    loginfo("Done.\n")
  rescue Exception => e
    logerror("[BASEX] #{e.message}\n")
  ensure
    session.close if session
  end
rescue Exception => e
  logerror("[BASEX] #{e.message}\n")
end

# Archives XML files to a specified directory
def archive_files(source, target)
  FileUtils.mkpath(target)
  Dir.glob(File.join(source, "**", "*.xml")).each do |file|
    loginfo("Archiving #{file} to archive directory...")
    FileUtils.mv(file, target)
    loginfo("Done.\n")
  end
end

# Deletes zip files in a specified directory
def delete_zips(target)
  Dir.glob(File.join(target, "*.zip")).each do |file|
    loginfo("Deleting #{file}...")
    FileUtils.rm(file)
    loginfo("Done.\n")
  end
  
end

# Unzips files in target directory
def unzip_files(target)
  Dir.glob(File.join(target, "*.zip")).each do |file|
    loginfo("Unzipping #{file}...")
    Zip::File.open(file) { |zipFile|
      zipFile.each { |zip|
        zipFile.extract(zip, File.join(target, zip.name))
      }
    }
    loginfo("Done.\n")
  end
end

# Copes files from source to target directory
def copy_files(source, target)
  delete_files_in_dir(target)
  FileUtils.mkpath(target)
  Dir.glob(File.join(source, "**", "*.{zip,xml}")).each do |file|
    loginfo("Copying #{file} to process directory...")
    FileUtils.cp(file, target)
    loginfo("Done.\n")
  end
end

def delete_files_in_dir(target)
  Dir.glob(File.join(target, "**", "*.*")).each do |file|
    FileUtils.rm(file)
  end
end

# Main method
begin
  copy_files(SOURCE_DIR, TARGET_DIR)
  unzip_files(TARGET_DIR)
  delete_zips(TARGET_DIR)
  process(TARGET_DIR)
  archive_files(TARGET_DIR, ARCHIVE_DIR)
end
