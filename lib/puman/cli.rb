require 'thor'

module Puman
  class CLI < Thor
    desc "list", "list all app linked with puma-dev"
    def list
      puts "Hello"
    end

    desc 'version', 'version'
    def version
      puts Puman::VERSION
    end
  end
end
