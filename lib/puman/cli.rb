require 'thor'
require_relative 'app'
require 'pry'

module Puman
  class CLI < Thor
    default_command :server

    def initialize(args, opts, config)
      super
      @app_list = AppList.new
    end

    desc 'version', 'version'
    def version
      puts Puman::VERSION
    end

    desc "list", "list all apps linked with puma-dev"
    def list
      puts @app_list.list
    end

    desc "server", "run rails server"
    def server
      exec @app_list.server_command
    end

    desc "symlink DIR_PATH", "create symlink into puma-dev directory."
    def symlink(dir)
      file = File.expand_path(dir)
      return puts 'invalid argument.' unless File.exists?(file)

      link_name = File.basename(file)
      if @app_list.include?(link_name)
        puts 'already exists.'
      else
        FileUtils::ln_s(File.join(Dir.pwd, link_name), File.join(PUMA_DEV_DIR, link_name))
        puts 'symlink created.'
      end
    end
  end
end
