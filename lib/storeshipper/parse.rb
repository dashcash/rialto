#!/usr/bin/env ruby
require 'parse-ruby-client'

module StoreShipper
  
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
    attr_reader :appId, :versionLog, :versionNumber, :versionCode, :versionLevel, :versionUrl
    
    # Methods
    
    def initialize(parseId, parseKey, id, log, number, code, level, url)
  
      @appId = id
      @versionLog = log
      @versionNumber = number
      @versionCode = code
      @versionLevel = level
      @versionUrl = url
      
      initParse(parseId, parseKey)
    end
    
    def initParse(id, key)
    	Parse.init 	:application_id	=> id,
    				      :api_key		=> key
    end
    
    def pushToParse
      
      puts "pushToParse #{appId}" 
      
      parseApplication = Parse.get APPLICATION_CLASSNAME, appId
      
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
    
    def existsInParse
      
      parseApplication = Parse.get APPLICATION_CLASSNAME, @appId
      
      if parseApplication != nil
      	puts parseApplication['applicationTitle'] + " loaded from Parse.com"
      else
      	puts "No Application with id " + appId + " found"
      	exit -1
      end
      
      parseAppVersion = Parse::Query.new(APPLICATION_VERSION_CLASSNAME)
      	.eq(APPLICATION_ID_PROPERTYNAME, parseApplication.pointer)
      	.eq(APPLICATION_VERSIONNUMBER_PROPERTYNAME, @versionNumber)
      	.get
        
      if (parseAppVersion != nil && parseAppVersion.length > 0)
        puts "Versions found: #{parseAppVersion.length}"
        return true
      else
        puts "No version found"
        return false
      end
        
    end
    
    def notifyViaParse(title, message, action, channel = "")
      
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
      		"parseAppID" => @cappId,
      		"newVersionCode" => @versionCode
      	}, channel)
        
      push.type = APPLICATION_TYPE
      push.save
      
      
    end
    
  end
  
end