#!/usr/bin/env ruby

require "StoreShipper/parse"

puts 'My executable works!'
#StoreShipper::Cli::Application.start(ARGV)

ARGV.each do |arg|  
   puts arg
end

if (ARGV.length == 0)
  puts "No argument"
end

case ARGV[0]
  
when "pushToParse"  

  puts "Pushing to Parse..."
  
  if (ARGV.length == 9)
    version = StoreShipper::Version.new(ARGV[1], ARGV[2], ARGV[3], ARGV[4], ARGV[5], ARGV[6], ARGV[7], ARGV[8])
    version.pushToParse
  else
      puts "Usage: "
  end

when "notifyViaParse"
  puts "Notifying via Parse..."
end