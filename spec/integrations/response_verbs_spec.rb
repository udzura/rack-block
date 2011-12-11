require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Response value verbs" do
  before do
  end

  it 'can halt with status code 404' do
    mock_app {
      use Rack::Block do
        bot_access { path('*'){ halt 404 } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/'
    last_response.should be_not_found
  end

  it 'can halt with status code 500' do
    mock_app {
      use Rack::Block do
        bot_access { path('*'){ halt 500 } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/'
    last_response.status.should eq(500)
  end

  it 'can redirect' do
    pending "not yet implemented"
    mock_app {
      use Rack::Block do
        bot_access { path('*'){ redirect 'http://www.google.com/' } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/'
    last_response.should be_redirect
  end

  it 'can point access to a dummy application' do
    pending "not yet implemented"
    require 'sinatra/base'
    dummy = Class.new(Sinatra::Base) do
      get '/' do
        "This is a dummy access to: #{request.path_info}"
      end
    end

    mock_app {
      use Rack::Block do
        bot_access do
          path('*') do
            dummy_app { dummy.new }
          end
        end
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/'
    last_response.status.should eq(500)
  end
end
