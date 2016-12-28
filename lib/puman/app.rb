module Puman
  class App
    attr_accessor :name, :host_port

    def initialize(name, host_port)
      @name = name
      @host_port = host_port
    end
  end

  class AppList
    attr_accessor :symlink_apps, :proxy_apps

    def initialize
      @symlink_apps = []
      @proxy_apps = []
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

    def server
      name = File.basename(git_dir_or_current_dir)
      apps = @proxy_apps.select{|app| app.name == name}
      if apps.size != 1
        puts 'no or multiple apps are defind.'
      else
        app = apps.first
        exec "bundle exec rails server -p #{app.host_port}" if app.host_port.match /^\d+$/
      end
    end

    private

    def root_directory?(path)
      File.directory?(path) && File.expand_path(path) == File.expand_path(File.join(path, '..'))
    end

    def git_dir_or_current_dir
      current_path = Dir.pwd
      until root_directory?(current_path)
        if File.exist?(File.join(current_path, '.git'))
          return current_path
        else
          current_path = File.dirname(current_path)
        end
      end
      Dir.pwd
    end
  end
end
