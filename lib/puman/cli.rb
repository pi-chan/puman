require 'thor'
require_relative 'app'

module Puman
  class CLI < Thor
    default_command :server

    def initialize(args, opts, config)
      super
      @app_list = AppList.new
    end

    desc "list", "list all apps linked with puma-dev"
    def list
      puts @app_list.list
    end

    desc "server", "run rails server"
    def server
      @app_list.server
    end

    desc 'version', 'version'
    def version
      puts Puman::VERSION
    end
  end
end
