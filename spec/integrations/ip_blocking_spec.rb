require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Blocking by IP" do
  before do
    Rack::Request.any_instance.stubs(:ip).returns('10.20.30.40')
  end

  it 'blocks accesses from a specific IP' do
    mock_app {
      use Rack::Block do
        ip_pattern '10.20.30.40' do
          halt 404
        end
      end
      run DEFAULT_APP
    }

    ['/', '/any', '/path/blocked'].each do |path|
      get path
      last_response.should be_not_found
    end
  end

  describe 'blocks accesses from a specific IP pattern' do
    before do
      mock_app {
        use Rack::Block do
          ip_pattern '10.20.30.' do
            halt 404
          end
        end
        run DEFAULT_APP
      }
    end
    
    it 'blocks 10.20.30.40 when supplied with 10.20.30.' do
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_not_found
      end
    end

    it 'blocks 10.20.30.50 when supplied with 10.20.30.' do
      Rack::Request.any_instance.stubs(:ip).returns('10.20.30.50')
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_not_found
      end
    end
  end

  describe 'blocks accesses from a specific IP pattern(with a netmask)' do
    before do
      mock_app {
        use Rack::Block do
          ip_pattern '10.20.30.0/24' do
            halt 404
          end
        end
        run DEFAULT_APP
      }
    end

    it 'blocks 10.20.30.40 when supplied with 10.20.30.0/24' do
      Rack::Request.any_instance.stubs(:ip).returns('10.20.30.40')
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_not_found
      end
    end

    it 'does not block 10.20.31.0 when supplied with 10.20.30.0/24' do
      Rack::Request.any_instance.stubs(:ip).returns('10.20.31.0')
      ['/', '/any', '/path/blocked'].each do |path|
        get path
        last_response.should be_ok
      end
    end
  end
end
