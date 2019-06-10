module Puman
  PUMA_DEV_DIR = File.join(Dir.home, '.puma-dev')

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
      Dir.chdir PUMA_DEV_DIR do
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
      string = []
      string << "-- symlink apps --"
      @symlink_apps.sort_by(&:name).each do |app|
        string << app.name
      end

      string << ''
      string << "-- proxy apps --"
      @proxy_apps.sort_by(&:host_port).each do |app|
        string << "#{app.host_port.strip.rjust(@proxy_max_length)} => #{app.name}"
      end
      string.join("\n")
    end

    def server_command
      name = File.basename(git_dir_or_current_dir)
      apps = @proxy_apps.select{|app| app.name == name}
      if apps.size == 1 && (app = apps.first).host_port.match(/^\d+$/)
        "WEBPACKER_DEV_SERVER_PORT=#{devserver_port(app)} WEBPACKER_DEV_SERVER_PUBLIC=localhost:#{devserver_port(app)} bundle exec rails server -p #{app.host_port}"
      end
    end

    def webpack_dev_server_command
      name = File.basename(git_dir_or_current_dir)
      apps = @proxy_apps.select{|app| app.name == name}
      if apps.size == 1 && File.exists?(File.join(Dir.pwd, 'bin/webpack-dev-server'))
         app = apps.first
        "WEBPACKER_DEV_SERVER_PORT=#{devserver_port(app)} WEBPACKER_DEV_SERVER_PUBLIC=localhost:#{devserver_port(app)} ./bin/webpack-dev-server"
      end
    end

    def include?(name)
      (@symlink_apps + @proxy_apps).map(&:name).include?(name)
    end

    private

    def devserver_port(app)
      (app.host_port.to_i + 10000).to_s
    end

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
