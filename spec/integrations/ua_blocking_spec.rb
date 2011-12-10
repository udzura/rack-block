require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Blocking by UA" do
  before do
    mock_app {
      use Rack::Block do
        bot_access do
          path '/foo' do
            halt 404
          end

          path '/bar' do
            redirect '/'
          end
        end
      end
      run DEFAULT_APP
    }
  end

  describe "Blocking built-in bot UA pattern" do

    it "blocks all bot access if no nesting block" do
      mock_app {
        use Rack::Block do
          bot_access do
            halt 404
          end
        end
        run DEFAULT_APP
      }
      
      header "User-Agent", "Googlebot"
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_not_found
      end
    end

    it "blocks specific paths" do
      mock_app {
        use Rack::Block do
          bot_access do
            path '/foo' do
              halt 404
            end
          end
        end
        run DEFAULT_APP
      }
      
      header "User-Agent", "Googlebot"
      get '/'
      last_response.should be_ok

      get '/foo'
      last_response.should be_not_found
    end

    it "does not block excepting specified paths"
  end
end
