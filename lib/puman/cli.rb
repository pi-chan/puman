require 'thor'
require 'pry'

module Puman
  App = Struct.new(:name, :host_port)

  class CLI < Thor
    def initialize(args, opts, config)
      super
      correct_apps
    end

    desc "list", "list all apps linked with puma-dev"
    def list
      puts "-- symlink apps --"
      @symlink_apps.sort_by(&:name).each do |app|
        puts app.name
      end

      puts
      puts "-- proxy apps --"
      @proxy_apps.sort_by(&:host_port).each do |app|
        puts "#{app.host_port.strip.rjust(@proxy_max_length)} => #{app.name}"
      end
    end

    desc "proxify", "make a text file with new host and port"
    def proxify
      puts 'hello'
    end

    desc 'version', 'version'
    def version
      puts Puman::VERSION
    end

    private

    def correct_apps
      return if !@proxy_apps.nil? && !@symlink_apps.nil?
      @proxy_apps = []
      @symlink_apps = []
      Dir.chdir File.join(Dir.home, '.puma-dev') do
        Dir.glob('*').each do |file|
          if File.symlink?(file)
            @symlink_apps.push App.new(file, nil)
          else
            host_port = File.read(file)
            @proxy_apps.push App.new(file, host_port)
          end
        end
      end
      @proxy_max_length = @proxy_apps.map {|app| app.host_port.strip.size}.max
    end
  end
end
