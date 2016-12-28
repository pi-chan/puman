require "spec_helper"

describe Puman do
  it 'has a version number' do
    expect(Puman::VERSION).not_to be nil
  end
end

describe Puman::AppList do
  context 'no files in puma-dev dir' do
    before :each do
      @app_list = Puman::AppList.new
    end

    specify '#symlink_apps' do
      expect(@app_list.symlink_apps.size).to eq(0)
    end

    specify '#proxy_apps' do
      expect(@app_list.proxy_apps.size).to eq(0)
    end

    specify '#list' do
      output = @app_list.list
      expect(output.strip).to eq(<<-EOF.strip)
-- symlink apps --

-- proxy apps --
EOF
    end
  end

  context 'app files and symlinks created in puma-dev dir' do
    before :each do
      File.open(PROXY_FILE_1, 'w') { |f| f.write '3001' }
      File.open(PROXY_FILE_2, 'w') { |f| f.write '3002' }
      FileUtils::ln_s(SAMPLE_DIR, SYMLINK_FILE) unless File.symlink?(SYMLINK_FILE)
      @app_list = Puman::AppList.new
    end

    specify '#symlink_apps' do
      expect(@app_list.symlink_apps.size).to eq(1)
    end

    specify '#proxy_apps' do
      expect(@app_list.proxy_apps.size).to eq(2)
    end

    specify '#list' do
      output = @app_list.list
      expect(output.match(/^symlink$/)).to be_truthy
      expect(output.match(/^3001\s+=> proxy1$/)).to be_truthy
      expect(output.match(/^3002\s+=> proxy2$/)).to be_truthy
    end

    context '#server_command' do
      specify 'in proxied app dir' do
        Dir.chdir SAMPLE_PROXY_DIR
        command = @app_list.server_command
        expect(command.match(/3001$/)).to be_truthy
      end

      specify 'in symlinked app dir' do
        Dir.chdir SAMPLE_DIR
        command = @app_list.server_command
        expect(command).to be_falsey
      end
    end
  end
end
