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

  it 'can redirect internal' do
    mock_app {
      use Rack::Block do
        bot_access { path('/foo/*'){ redirect '/' } }
      end
      run DEFAULT_APP
    }

    header "User-Agent", "Googlebot"
    get '/foo/bar'
    last_response.should be_redirect

    follow_redirect!
    last_response.body.should match /It is summer/
  end

  context 'doubling application' do
    require 'sinatra/base'
    let :dummy do
      Class.new(Sinatra::Base) do
        get '/' do
          "This is a dummy access to: #{request.path_info}"
        end
      end
    end

    it 'can point access to a dummy application' do
      dummy = dummy()
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
      last_response.body.should match /This is a dummy access to: \//

      get '/not-found'
      last_response.should be_not_found
    end

    it 'should be called with env' do
      dummy = dummy()
      mock_app {
        use Rack::Block do
          bot_access do
            path('*') do
              double do |env|
                # Sinatra::Base and its subclasses have a #call method in his class methods
                dummy.call(env)
              end
            end
          end
        end
        run DEFAULT_APP
      }

      header "User-Agent", "Googlebot"
      get '/'
      last_response.body.should match /This is a dummy access to: \//
    end

    it 'should be aliased by #double' do
      dummy = dummy()
      mock_app {
        use Rack::Block do
          bot_access do
            path('*') do
              double { dummy.new }
            end
          end
        end
        run DEFAULT_APP
      }

      header "User-Agent", "Googlebot"
      get '/'
      last_response.body.should match /This is a dummy access to: \//
    end
  end
end
