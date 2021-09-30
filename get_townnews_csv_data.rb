require 'net/ssh'
require 'uri'
require 'net/sftp'
require 'net/ssh/proxy/http'
require 'csv'
require 'date'

def download_TownNews_FTP_files(domain)
  puts "Connecting to TownNews"
  
  domain = domain.upcase
  townnews_domain_name = ENV['TOWNNEWS_'+domain+'_DOMAIN_NAME']
  townnews_domain_ftp_login = ENV['TOWNNEWS_'+domain+'_FTP_LOGIN']
  townnews_domain_ftp_password = ENV['TOWNNEWS_'+domain+'_FTP_PASSWORD']
  raise StandardError if townnews_domain_name.empty? or townnews_domain_ftp_login.empty? or townnews_domain_ftp_password.empty?

  Net::SFTP.start(townnews_domain_name,townnews_domain_ftp_login,{:password => townnews_domain_ftp_password,:port=>122}) do |sftp|
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
  
  rescue
    puts "\n**************************************************************************************************"
    puts " TownNews FTP Connection Error: cannot connect to domain '"+domain+"'"
    puts " Check FTP connection setting within the secret.rb file:"
    puts "      domain name = "+townnews_domain_name
    puts "      login = "+townnews_domain_ftp_login
    puts "      password = ******"
    puts "**************************************************************************************************"
    puts "\n\n\n"
    exit!
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