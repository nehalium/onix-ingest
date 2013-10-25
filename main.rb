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
require './config.rb'
require './logging.rb'

def get_database_connection()
  return Mysql.new(MYSQL_HOST, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE)
end

# Imports a given xquery result into the database
def import_to_database(record, db)
  loginfo("Importing product ref #{record.xpath("/record/product/ONIXProductRef").text}.\n", 2)
  names = Array.new
  values = Array.new
  # Read each product child node ignoring those with attribute ignore="true"
  record.xpath("/record/product/*").each do |node|
    if (node.xpath("@ignore").text != "true")
      names << node.name
      type = node.xpath("@type").text
      value = Mysql.escape_string(node.text)
      # String-ify if a string value, otherwise, take as is
      case type
        when "decimal", "int", "bit"
          values << ((value != '')? value : "NULL")
        else
          values << ((value != '')? "'#{value}'" : "NULL")
      end
    end
  end
  # Include opened and updated timestamps
  names << "opened"
  values << "'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  names << "updated"
  values << "'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  
  sql = "INSERT INTO #{TARGET_TABLE} (#{names.join(',')}) VALUES (#{values.join(',')});"

  loginfo("SQL: #{sql}\n", 3)
  db.query(sql)
end

# Truncates the database table
def clear_database(db)
  loginfo("Truncating table...", 1)
  db.query("truncate #{TARGET_TABLE};")
  loginfo("Done.\n", 1)
end

# Processes a record from the Base-X query
def process_record(record, db)
  import_to_database(Nokogiri::XML(record), db)
end

# Runs query and imports the results
def process_records(session)
  # Read xquery file
  query = session.query(File.read(File.join(Dir.pwd, "main.xq")))
  # Open database connection
  db = get_database_connection()
  clear_database(db)
  loginfo("Processing...\n", 1)
  # Loop through each result from xquery
  while query.more do
    process_record(query.next, db)
  end
  loginfo("Done.\n", 1)
rescue Mysql::Error => e
  logerror("#{e.errno}:#{e.error}\n")
  logerror("#{e.backtrace.join("\n")}\n")
ensure
  query.close() if query
  db.close if db
end

def print_records_in_aggregate(session)
  puts session.execute("RUN #{ROOT_DIR}\\basex\\test.xq")
end

# Opens a connection to Base-X and runs xquery
def process(dir)
  session = BaseXClient::Session.new(BASEX_HOST, BASEX_PORT, BASEX_USERNAME, BASEX_PASSWORD)
  begin
    loginfo("Opening Base-X DB...", 1)
    session.execute("CREATE DATABASE ONIX #{dir}")
    session.execute("OPEN ONIX")
    loginfo("Done.\n", 1)
    process_records(session)
    loginfo("Closing Base-X DB...", 1)
    session.execute("DROP DB ONIX")
    loginfo("Done.\n", 1)
  rescue Exception => e
    logerror("[BASEX] #{e.message}\n")
  ensure
    session.close if session
  end
rescue Exception => e
  logerror("#{e.message}\n")
  logerror("#{e.backtrace.join("\n")}\n")
end

# Archives XML files to a specified directory
def archive_files(source, target)
  create_dir(target)
  Dir.glob(File.join(source, "**", "*.xml")).each do |file|
    loginfo("Archiving #{file} to archive directory...", 1)
    FileUtils.mv(file, target)
    loginfo("Done.\n", 1)
  end
end

# Deletes zip files in a specified directory
def delete_zips(target)
  Dir.glob(File.join(target, "*.zip")).each do |file|
    loginfo("Deleting #{file}...", 1)
    FileUtils.rm(file)
    loginfo("Done.\n", 1)
  end
  
end

# Unzips files in target directory
def unzip_files(target)
  Dir.glob(File.join(target, "*.zip")).each do |file|
    loginfo("Unzipping #{file}...", 1)
    Zip::File.open(file) do |zipFile|
      zipFile.each do |zip|
        zipFile.extract(zip, File.join(target, zip.name))
      end
    end
    loginfo("Done.\n", 1)
  end
end

# Copes files from source to target directory
def copy_files(source, target)
  delete_files_in_dir(target)
  create_dir(target)
  Dir.glob(File.join(source, "**", "*.{zip,xml}")).each do |file|
    loginfo("Copying #{file} to process directory...", 1)
    FileUtils.cp(file, target)
    loginfo("Done.\n", 1)
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
