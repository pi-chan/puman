require "spec_helper"

describe Puman do
  it 'has a version number' do
    expect(Puman::VERSION).not_to be nil
  end
end

describe Puman::AppList do
  before do
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
end
