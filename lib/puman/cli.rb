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
      server_command = @app_list.server_command
      webpack_dev_server_command = @app_list.webpack_dev_server_command

      if server_command.nil?
        puts 'no or multiple apps are defind.'
        exit 1
      end

      if webpack_dev_server_command
        spawn webpack_dev_server_command
      end
      exec server_command
    rescue
    end

    desc "symlink DIR_PATH", "create symlink in puma-dev directory."
    def symlink(dir)
      target_dir, basename = target_directory(dir)
      if @app_list.include?(basename)
        puts 'already exists.'
      elnse
        FileUtils::ln_s(target_dir, File.join(PUMA_DEV_DIR, basename))
        puts 'symlink created.'
      end
    end

    desc "proxy DIR_PATH", "create proxy file in puma-dev directory."
    def proxy(dir)
      target_dir = target_directory(dir)
      if @app_list.include?(target_dir)
        puts 'already exists.'
      else
        puts 'proxy option has not been implemented yet.'
      end
    end

    private

    def target_directory(arg_dir)
      file = File.expand_path(arg_dir)
      unless File.exists?(file)
        puts 'invalid argument.'
        exit 1
      end
      [file, File.basename(file)]
    end
  end
end
