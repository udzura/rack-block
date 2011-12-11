require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Path matching patterns" do
  it 'matching path should specified with `/\' starting' do
    mock_app {
      use Rack::Block do
        bot_access { path('/foo'){ halt 404 } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/foo'
    last_response.should be_not_found

    get '/bar/foo'
    last_response.should be_ok
  end

  it 'matching glob `*\' should be a wildcard' do
    mock_app {
      use Rack::Block do
        bot_access { path('/foo/*/bar'){ halt 500 } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/foo/123/bar'
    last_response.should be_server_error

    get '/foo/hogehoge/bar/4'
    last_response.should be_server_error
  end

  it 'path including `.\' should be sane' do
    mock_app {
      use Rack::Block do
        bot_access { path('/favicon.ico'){ halt 404 } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/favicon.ico'
    last_response.should be_not_found

    header "User-Agent", "Googlebot"
    get '/favicon_ico'
    last_response.should be_ok
  end
end
