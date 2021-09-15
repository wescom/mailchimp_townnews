require 'net/ssh'
require 'uri'
require 'net/sftp'
require 'net/ssh/proxy/http'
require 'csv'
require 'date'

def download_TownNews_FTP_files()
  puts "Connecting to TownNews"
  Net::SFTP.start(ENV['TOWNNEWS_SERVER_DOMAIN_NAME'],ENV['TOWNNEWS_SERVER_FTP_LOGIN'],{:password => ENV['TOWNNEWS_SERVER_FTP_PASSWORD'],:port=>122}) do |sftp|
    # list the entries in a directory
    #sftp.dir.foreach("/dailyuser/export/audience") do |entry|
    #  puts entry.longname
    #end
    # download files from the remote host
    puts "Downloading files from TownNews ..."
    registered_user_file = ENV['TOWNNEWS_REGISTERED_USERS_FILE']
    subscriber_file = ENV['TOWNNEWS_SUBSCRIBERS_FILE']
    puts "   " + registered_user_file
    puts "   " + subscriber_file
    sftp.download!(registered_user_file, "./userexport.csv")
    sftp.download!(subscriber_file, "./subscribers.csv")
    puts "Download complete."
  end
  
  rescue MailchimpMarketing::ApiError => e
    puts "Connection Error: #{e}"
end

def get_townnews_users()
  #read users into array
  townnews_users = CSV.parse(File.read("userexport.csv"), headers: true)
  todays_date = Date.parse(DateTime.now.to_s)

  # filter array to new records based on ENV['DAYS_PAST_TO_IMPORT']
  townnews_users.delete_if do |element|
    record_date = Date.parse(element["creationdate"])
    if (todays_date - record_date).to_i > ENV['DAYS_PAST_TO_IMPORT'].to_i
      true
    else
      false
    end  
  end
  
  puts "TownNews registered users in file userexport.csv - " + townnews_users.length.to_s
  return townnews_users
end

def get_townnews_subscribers()
  #read subscribers into array
  townnews_subscribers = CSV.parse(File.read("subscribers.csv"), headers: true)
  todays_date = Date.parse(DateTime.now.to_s)

  # filter array to new records based on ENV['DAYS_PAST_TO_IMPORT']
  townnews_subscribers.delete_if do |element|
    record_date = Date.parse(element["transactionTime"])
    if (todays_date - record_date).to_i > ENV['DAYS_PAST_TO_IMPORT'].to_i
      true
    else
      false
    end
  end
  
  puts "TownNews subscribers in file subscribers.csv - " + townnews_subscribers.length.to_s
  return townnews_subscribers
end