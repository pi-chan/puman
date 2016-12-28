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
end
