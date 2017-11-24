require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_app_helper')

describe "Blocking all requests" do
  before do
    mock_app do
      use Rack::Block do
        all_pattern { halt 404 }
      end
      run DEFAULT_APP
    end
  end

  it 'blocks any request' do
    get '/'
    last_response.should be_not_found
  end

end
