require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "There is no problem that the #mock_app helper works" do
  before do
    mock_app do
      map '/nil' do
        run lambda {|env| [404, {"Content-Type" => "text/plain"}, ["It is no summer"]] }
      end

      map '/auth' do
        use Rack::Auth::Basic, "fobbiden" do |u, p| false end
        run lambda {|env| [200, {"Content-Type" => "text/plain"}, ["Not reachable"]] }
      end

      map '/' do
        run lambda {|env| [200, {"Content-Type" => "text/plain"}, ["It is summer"]] }
      end
    end
  end

  it "works on a normal access" do
    lambda { get '/' }.should_not raise_error
    last_response.should be_ok
  end

  it "works when not found" do
    get '/nil'
    last_response.should be_not_found
  end

  it "works using rack middleware" do
    get '/auth'
    last_response.status.should eq 401
  end
end
