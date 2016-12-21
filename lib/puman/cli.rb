require 'thor'

module Puman
  class CLI < Thor
    desc "proxy", "list proxyied apps linked with puma-dev"
    def proxy
      portmaps = {}
      Dir.chdir File.join(Dir.home, '.puma-dev') do
        Dir.glob('*').each do |file|
          unless File.symlink?(file)
            port = File.read(file)
            portmaps[port] = file
          end
        end
      end

      portmaps.sort.each do |port, proj|
        puts "#{port.strip} => #{proj}"
      end
    end

    desc "proxify", "make a text file with new port number"
    def proxify
      puts 'hello'
    end

    desc 'version', 'version'
    def version
      puts Puman::VERSION
    end
  end
end
