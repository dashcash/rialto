# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rialto/version"

Gem::Specification.new do |s|
  s.name        = 'rialto'
  s.version     = Rialto::VERSION
  s.platform    = Gem::Platform::RUBY
  
  s.date        = '2015-03-09'
  
  s.summary     = "Gem that manages Android apps shipping"
  s.description = "The gem builds, manages metadata, ships & notifies users"
  
  s.authors     = ["htquach"]
  s.email       = 'ht@quach.com'
  
  s.files       = ["lib/main.rb"]
  
  s.homepage    = 'http://github.com/dashcash/rialto'
  s.license     = 'MIT'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  #s.add_dependency 'thor', '~> 0.18'
  
end