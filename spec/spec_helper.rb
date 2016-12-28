$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "puman"
require 'fakefs/safe'

PUMA_DEV_DIR = File.join(Dir.home, '.puma-dev')
SAMPLE_DIR = File.join(Dir.home, 'src', 'sample')
PROXY_FILE = File.join(Dir.home, '.puma-dev', 'proxy')
SYMLINK_FILE = File.join(Dir.home, '.puma-dev', 'symlink')

RSpec.configure do |config|
  config.order = 'random'

  config.before(:all) do
    FakeFS.activate!
    FileUtils::mkdir_p PUMA_DEV_DIR
    FileUtils::mkdir_p SAMPLE_DIR
    File.open(PROXY_FILE + '1', 'w') { |f| f.write '3001' }
    File.open(PROXY_FILE + '2', 'w') { |f| f.write '3002' }
    FileUtils::ln_s(SAMPLE_DIR, SYMLINK_FILE) unless File.symlink?(SYMLINK_FILE)
  end

  config.after(:all) do
    FakeFS.deactivate!
  end
end
