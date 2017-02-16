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
      command = @app_list.server_command
      if command
        exec command
      else
        puts 'no or multiple apps are defind.'
        exit 1
      end
    end

    desc "create DIR_PATH", "create symlink in puma-dev directory."
    option :symlink, aliases: '-t', type: :boolean
    option :proxy, aliases: '-p', type: :boolean
    def create(dir)
      check_create_options
      proxy = options[:proxy]
      symlink = options[:symlink]
      target_dir = target_directory(dir)
      if @app_list.include?(target_dir)
        puts 'already exists.'
      elsif symlink
        FileUtils::ln_s(File.join(Dir.pwd, target_dir), File.join(PUMA_DEV_DIR, target_dir))
        puts 'symlink created.'
      elsif proxy
      end
    end

    private

    def target_directory(arg_dir)
      file = File.expand_path(arg_dir)
      unless File.exists?(file)
        puts 'invalid argument.'
        exit 1
      end
      File.basename(file)
    end

    def check_create_options
      proxy = options[:proxy]
      symlink = options[:symlink]
      if (proxy && symlink)
        puts "Cannot pass both '--proxy' and '--symlink'."
        exit 1
      elsif (!proxy && !symlink)
        puts "'--proxy' or '--symlink' must be passed."
        exit 1
      end
    end
  end
end
