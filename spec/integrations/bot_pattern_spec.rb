require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Blocking search bots" do
  def access_root_as(ua)
    header "User-Agent", ua
    get '/'
  end

  before do
    mock_app do
      use Rack::Block do
        bot_access { halt 404 }
      end
      run DEFAULT_APP
    end
  end

  it 'blocks google bot' do
    access_root_as 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
    last_response.should be_not_found
  end

  it 'blocks msn bot' do
    access_root_as 'msnbot/1.1 (+http://search.msn.com/msnbot.htm)'
    last_response.should be_not_found
  end

  it 'blocks bing bot' do
    access_root_as 'Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)'
    last_response.should be_not_found
  end

  it 'blocks yahoo! slurp' do
    access_root_as 'Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)'
    last_response.should be_not_found
  end

  it 'blocks baiduspider' do
    access_root_as 'Baiduspider+(+http://www.baidu.com/search/spider_jp.html)'
    last_response.should be_not_found
  end
end
