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

# Imports a given xquery result into the database
def import_to_database(record)
  names = Array.new
  values = Array.new
  record.xpath("/record/product/*").each do |node|
    if (node.xpath("@ignore").text != "true")
      names << node.name
      type = node.xpath("@type").text
      value = Mysql.escape_string(node.text)
      case type
        when "decimal", "int", "bit"
          values << ((value != '')? value : "NULL")
        else
          values << ((value != '')? "'#{value}'" : "NULL")
      end
    end
  end
  names << "opened"
  values << "'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  names << "updated"
  values << "'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  
  sql = "INSERT INTO productmasterfile (#{names.join(',')}) VALUES (#{values.join(',')});"

  if (VERBOSE_LOGGING)
    loginfo("SQL: #{sql}\n")
  end
  db = Mysql.new(MYSQL_HOST, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE)
  db.query(sql)
  #st = db.prepare(sql)
  #st.execute(values)
rescue Mysql::Error => e
  logerror("[MYSQL] #{e.errno}:#{e.error}\n")
ensure
  #st.close if st
  db.close if db
end

# Processes a record from the Base-X query
def process_record(record)
  import_to_database(Nokogiri::XML(record))
end

# Runs query and imports the results
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

# Opens a connection to Base-X and runs xquery
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
  create_dir(target)
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
    Zip::File.open(file) do |zipFile|
      zipFile.each do |zip|
        zipFile.extract(zip, File.join(target, zip.name))
      end
    end
    loginfo("Done.\n")
  end
end

# Copes files from source to target directory
def copy_files(source, target)
  delete_files_in_dir(target)
  create_dir(target)
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
