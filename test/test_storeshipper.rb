require 'minitest/autorun'
require 'storeshipper'

class StoreShipperTest < Minitest::Unit::TestCase
  
  def test_creating_a_version

    parseID   = "aParseID"
    parseKey  = "aKey"
    appID     = "anAppId"
    appLog    = "anAppLog"
    appNumber = "anAppNumber"
    appCode   = "anAppCode"
    appLevel  = "anAppLevel"
    appURL    = "anAppURL"
    
    version = StoreShipper::Version.new(parseID , parseKey , appID ,appLog, appNumber, appCode, appLevel, appURL)
    
    assert !(version.nil?)

  end

end