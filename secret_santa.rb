#!/usr/bin/ruby
require 'net/smtp'

PRINT_RESULTS = true # Print results to screen?
EMAIL_RESULTS = false # email the results?


pool = ["sanket.arora@paytmmall.com",
        "aman6.jain@paytmmall.com",
        "adarsh.tripathi@paytmmall.com"]
        
avail = pool.dup
pairs = []

def send_email(from, from_alias, to, to_alias, subject, message)
  msg = <<END_OF_MESSAGE
From: #{from_alias} <#{from}>
To: #{to_alias} <#{to}>
Subject: #{subject}
  
#{message}
END_OF_MESSAGE
  
  Net::SMTP.start('localhost') do |smtp|
    puts "sending mail #{from} to #{to}"
    smtp.send_message msg, from, to
  end
end

pool.each do |secret_santa|
  loop do
    index = (rand * avail.length).to_i
    recipient = avail[index]
    unless recipient == secret_santa
      avail.delete_at(index)
      pairs << [secret_santa, recipient]
      break
    end
  end
end

pairs.each do |secret_santa,recipient| 
  from = "santa@paytmmall.com"
  from_alias = "santa"
  to = secret_santa
  to_alias = secret_santa
  
  subject = "SECRET SANTA -- ho ho ho"
  message = "You are secret santa of: #{recipient} \n Enjoy Christmas with all your folks!!"
  send_email(from, from_alias, to, to_alias, subject, message) if EMAIL_RESULTS
  puts "#{secret_santa}\t\t\t::\t#{recipient}" if PRINT_RESULTS
end
