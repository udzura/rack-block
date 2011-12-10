RSpec.configure do |config|
  config.include Rack::Test::Methods
end

DEFAULT_APP = lambda {|env| [200, {"Content-Type" => "text/plain"}, ["It is summer"]] }
@app = nil
def app
  @app || DEFAULT_APP
end

require 'rack/builder'
def mock_app(&block)
  @app = Rack::Builder.new(&block)
end
