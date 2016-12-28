$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "puman"
require 'fakefs/safe'

PUMA_DEV_DIR = File.join(Dir.home, '.puma-dev')
SAMPLE_DIR = File.join(Dir.home, 'src', 'sample')
SAMPLE_PROXY_DIR = File.join(Dir.home, 'src', 'proxy1')
PROXY_FILE_1 = File.join(Dir.home, '.puma-dev', 'proxy1')
PROXY_FILE_2 = File.join(Dir.home, '.puma-dev', 'proxy2')
SYMLINK_FILE = File.join(Dir.home, '.puma-dev', 'symlink')

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    FakeFS.activate!
    FakeFS::FileSystem.clear
    FileUtils::mkdir_p PUMA_DEV_DIR
    FileUtils::mkdir_p SAMPLE_DIR
    FileUtils::mkdir_p SAMPLE_PROXY_DIR
  end

  config.after(:each) do
    FakeFS.deactivate!
  end
end
