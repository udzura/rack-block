module Rack::Block::DSL
  module Responses
    def detect_matching_pattern
      if in_ua_block?
        ua_matchers[@_current_matching_ua_pattern] ||= {}
      end
    end

    def halt(code, opts={})
      if @_current_matching_path
        path = Regexp.compile("^" + @_current_matching_path.gsub(/\./, '\\.').gsub(/\*/, '.*'))
        current_matchers = detect_matching_pattern
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
