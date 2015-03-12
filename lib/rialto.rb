#!/usr/bin/env ruby
require "rialto/main"

case ARGV[0]

  #when "build"
  
when "parseUpdate"
  
  if (ARGV.length == 2)
    version = Rialto::Version.new()
    version.parseUpdate(ARGV[1])
  else
    puts "Usage: rialto parseUpdate [versionFilepath]"
  end
  
  #when "deploy"

when "parseNotify"
  
  if (ARGV.length == 2)
    version = Rialto::Version.new()
    version.parseNotify(ARGV[1])
  else
    puts "Usage: rialto parseNotify [notificationFilepath]"
  end
  
else
  puts "Usage: build | storeDeploy | playStoreDeploy | parseUpdate | parseNotify"
end