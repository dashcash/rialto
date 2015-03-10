require "thor"

module StoreShipper
  
  module Cli
  
    class Application < Thor

      desc 'hello NAME', 'Display greeting with given NAME'
     
      def hello(name)
        puts "Hello #{name}"
      end
    
    end
  
  end

end