module Rack::Block::DSL
  module Responses
    def halt(code, opts={})
      if @_current_matching_path
        path = Regexp.compile("^" + @_current_matching_path.sub(/\*/, '.*'))
        current_matchers = (self.ua_matchers[@_current_matching_ua_pattern] ||= {})
        current_matchers[path] = [:do_halt, code, opts]
      else
        path '*' do
          halt code, opts
        end
      end
    end

    def do_halt(code, opts={})
      headers = {"Content-Type" => "text/plain"}.merge(opts[:headers] || {})
      body = opts[:body] || "Halt!"
      return [code, headers, [body]]
    end
  end
end
