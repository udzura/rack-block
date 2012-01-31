require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Passing through accesses" do
  describe "Normal browser's access" do

    it "should pass the server response" do
      mock_app {
        use Rack::Block do
          bot_access do
            halt 404
          end
        end
        run DEFAULT_APP
      }
      
      header "User-Agent", "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)"
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_ok
        last_response.body.should match /It is summer/
      end
    end
  end
end
