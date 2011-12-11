require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Blocking by UA" do
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
      get '/foo'
      last_response.should be_not_found
    end

    it "does not block excepting specified paths" do
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
    end
  end

  describe "Blocking customized UA pattern" do
    before do
      mock_app {
        use Rack::Block do
          ua_pattern /MSIE [678]\.[05].*Windows/ do
            halt 404
          end
        end
        run DEFAULT_APP
      }
    end

    it "blocks customized UA" do
      header "User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_not_found
      end
    end

    it "doesn't block non-matching UA" do
      header "User-Agent", "Mozilla/5.0 (Ubuntu; X11; Linux i686; rv:8.0) Gecko/20100101 Firefox/8.0"
      ['/', '/any', '/path/not-blocked'].each do |path|
        get path
        last_response.should be_ok
      end
    end
  end
end
