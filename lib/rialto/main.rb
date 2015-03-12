#!/usr/bin/env ruby
require 'parse-ruby-client'
require 'nokogiri'

module Rialto
  
  # An application
  
  class Application
  end
  
  # A version of an application
  
  class Version
    
    # Constants
    
    # Parse DB related
    
    APPLICATION_CLASSNAME                     = "Application"
    APPLICATION_VERSION_CLASSNAME             = "ApplicationVersion"
    
    APPLICATION_ID_PROPERTYNAME               = "applicationId"
    APPLICATION_TITLE_PROPERTYNAME            = "applicationTitle"
    
    APPLICATION_VERSIONNUMBER_PROPERTYNAME    = "versionNumber"
    APPLICATION_VERSIONCODE_PROPERTYNAME      = "versionCode"
    APPLICATION_VERSIONCHANGELOG_PROPERTYNAME = "versionChangeLog"
    APPLICATION_VERSIONURL_PROPERTYNAME       = "versionURL"
    APPLICATION_VERSIONLEVEL_PROPERTYNAME     = "versionLevel"
    
    APPLICATION_TYPE                          = "android"
    
    # Attributes
    attr_reader :parseId, :parseKey, :appId, :versionLog, :versionNumber, :versionCode, :versionLevel, :versionUrl
    
    # Methods
    
    def initialize()
    end
    
    def initVersion(file)
      
      f = File.open(file)
      doc = Nokogiri::XML(f)
      f.close
      
      version = doc.xpath("//version/item").map do |i|
        {"key" => i.xpath("key"), "value" => i.xpath("value")}
      end
      
      version.each { |item|
        
        key = item["key"][0].content
        value = item["value"][0].content
        
        puts "#{key}, #{value}"
        
        case key
        when "parseId"
          @parseId = value  
        when "apiKey"
          @parseKey = value 
        when "appId"
          @appId = value
        when "versionCode"
          @versionCode = value  
        when "versionLog"
          @versionLog = value  
        when "versionNumber"
          @versionNumber = value  
        when "versionLevel"
          @versionLevel = value 
        when "versionUrl"
          @versionUrl = value 
        end
      }
      
    end
    
    def initParse(id, key)
    	Parse.init 	:application_id	=> id,
    				      :api_key		=> key
    end
    
    def build
      puts "build: coming soon"
    end
    
    def deploy
      puts "deploy: coming soon"
    end
    
    def updateDatabase(file)
      puts "updateDatabase / Parse / #{appId}" 

      initVersion(file)
      initParse(@parseId, @parseKey)
      
      parseApplication = Parse.get APPLICATION_CLASSNAME, @appId
      
      if parseApplication != nil
      	puts parseApplication[APPLICATION_TITLE_PROPERTYNAME] + " loaded from Parse.com"
      else
      	puts "No Application with id #{appId} found"
      	exit -1
      end
      
      parseAppVersion = Parse::Query.new(APPLICATION_VERSION_CLASSNAME)
      	.eq(APPLICATION_ID_PROPERTYNAME, parseApplication.pointer)
      	.eq(APPLICATION_VERSIONNUMBER_PROPERTYNAME, @versionNumber)
      	.get
        
      if (parseAppVersion != nil && parseAppVersion.length > 0)
        puts "Versions found: #{parseAppVersion.length}"
      	puts "Updating existing ApplicationVersion"

      	version = parseAppVersion[0]
        
      	version[APPLICATION_VERSIONURL_PROPERTYNAME]	        = @versionUrl
      	version[APPLICATION_VERSIONCHANGELOG_PROPERTYNAME]		= @versionLog
        version[APPLICATION_VERSIONCODE_PROPERTYNAME]         = @versionCode.to_i
        
      	version.save
        
        puts "Application updated"
        
      else
        puts "No version found. Creating it."
        
      	newVersion = Parse::Object.new(APPLICATION_VERSION_CLASSNAME)
        
      	newVersion[APPLICATION_ID_PROPERTYNAME]		            = parseApplication.pointer
      	newVersion[APPLICATION_VERSIONCODE_PROPERTYNAME]		  = @versionCode.to_i
      	newVersion[APPLICATION_VERSIONNUMBER_PROPERTYNAME]		= @versionNumber
      	newVersion[APPLICATION_VERSIONCHANGELOG_PROPERTYNAME]	= @versionLog
      	newVersion[APPLICATION_VERSIONURL_PROPERTYNAME]			  = @versionUrl
      	newVersion[APPLICATION_VERSIONLEVEL_PROPERTYNAME]		  = @versionLevel
      	
        newVersion.save
        
        puts "Application created"
        
      end
      
    end
    
    def notify(file)
      
      puts "Notification #{file}"
      
      f = File.open(file)
      doc = Nokogiri::XML(f)
      f.close
      
      notification = doc.xpath("//notification/item").map do |i|
        {"key" => i.xpath("key"), "value" => i.xpath("value")}
      end
      
      puts notification
        
      title = ""
      message = ""
      action = ""
      channel = ""
      
      notification.each { |item|
        
        key = item["key"][0].content
        value = item["value"][0].content
        
        puts "#{key}, #{value}"
        case key
        when "parseId"
          @parseId = value  
        when "apiKey"
          @parseKey = value 
        when "appId"
          @appId = value
        when "versionCode"
          @versionCode = value  
        when "title"
          title = value  
        when "message"
          message = value  
        when "action"
          action = value 
        when "channel"
          channel = value 
        end
      }
      
      puts "#{parseId}, #{parseKey}"
      
      initParse(@parseId, @parseKey)
      
      parseApplication = Parse.get APPLICATION_CLASSNAME, @appId
      
      if parseApplication != nil
      	puts parseApplication[APPLICATION_TITLE_PROPERTYNAME] + " found in Parse.com"
      else
      	puts "No Application with id #{appId} found"
      	exit -1
      end
      
      # Default value for title
      if (title.length == 0)
        puts "Title is set to default: Application name & version"
        finTitle = "#{parseApplication[APPLICATION_TITLE_PROPERTYNAME]} - #{versionNumber}"
      else
        puts "Title is set to: #{title}"
        finTitle = title
      end
      
      push = Parse::Push.new(
      	{
      		"title" => finTitle,
      		"alert" => message,
      		"action" => action,
      		"parseAppID" => @appId,
      		"newVersionCode" => @versionCode
      	}, channel)
        
      push.type = APPLICATION_TYPE
      push.save
      
      
    end
    

    
  end
  
end