module Rack
  class Block
    module DSL
      autoload :Matchers, 'rack/block/dsl/matchers'
      autoload :Responses, 'rack/block/dsl/responses'
    end
  end
end

