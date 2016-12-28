require "spec_helper"

PUMA_DEV_DIR = '~/.puma-dev'
SAMPLE_DIR = '~/src/sample'

describe Puman do
  before do
    FakeFS.activate!
    Dir::mkdir_p PUMA_DEV_DIR
    Dir::mkdir_p SAMPLE_DIR
    File.open('~/.puma-dev/proxy', 'w') { |f| f.write 'Hello, World.' }
    File.symlink('~/.puma-dev/symlink', SAMPLE_DIR)
  end

  after do
    FakeFS.deactivate!
  end

  it 'has a version number' do
    expect(Puman::VERSION).not_to be nil
  end

  it '' do
    expect(false).to eq(true)
  end
end
