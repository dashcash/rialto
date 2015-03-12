#!/usr/bin/env ruby
require "rialto/main"

ARGV.each do |arg|  
   puts arg
end

if (ARGV.length == 0)
  puts "No argument"
end

case ARGV[0]

  #when "build"
  
when "updateParse"
  
  if (ARGV.length == 2)
    version = Rialto::Version.new()
    version.updateDatabase(ARGV[1])
  else
    puts "Usage: storeshipper updateDatabase [version_filepath]"
  end
  
  #when "deploy"

when "notify"
  
  if (ARGV.length == 2)
    version = Rialto::Version.new()
    version.notify(ARGV[1])
  else
    puts "Usage: storeshipper deploy [version_filepath]"
  end
  
  
else
  puts "Usage: build | deploy | deployAndNotify"
end