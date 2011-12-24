require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Blocking by IP" do
  it 'blocks accesses from a specific IP' do
    mock_app {
      use Rack::Block do
        ip_pattern '10.20.30.40' do
          halt 404
        end
      end
      run DEFAULT_APP
    }
      
    header "X-Forwarded-For", "10.20.30.40"
    ['/', '/any', '/path/blocked'].each do |path|
      get path
      last_response.should be_not_found
    end
  end

  it 'blocks accesses from a specific IP pattern' do
    mock_app {
      use Rack::Block do
        ip_pattern '10.20.30.' do
          halt 404
        end
      end
      run DEFAULT_APP
    }
      
    header "X-Forwarded-For", "10.20.30.40"
    ['/', '/any', '/path/blocked'].each do |path|
      get path
      last_response.should be_not_found
    end

    header "X-Forwarded-For", "10.20.30.50"
    ['/', '/any', '/path/blocked'].each do |path|
      get path
      last_response.should be_not_found
    end
  end

  it 'blocks accesses from a specific IP pattern(with a netmask)' do
    pending "Not yet implemented, netmask expressions to Regexp or some other matching methods..."
    mock_app {
      use Rack::Block do
        ip_pattern '10.20.30.0/24' do
          halt 404
        end
      end
      run DEFAULT_APP
    }
      
    header "X-Forwarded-For", "10.20.30.40"
    ['/', '/any', '/path/blocked'].each do |path|
      get path
      last_response.should be_not_found
    end

    header "X-Forwarded-For", "10.20.30.50"
    ['/', '/any', '/path/blocked'].each do |path|
      get path
      last_response.should be_not_found
    end
  end
end
