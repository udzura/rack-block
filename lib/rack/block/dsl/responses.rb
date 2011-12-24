module Rack::Block::DSL
  module Responses
    def detect_matching_pattern
      if in_ua_block?
        ua_matchers[@_current_matching_ua_pattern] ||= {}
      elsif in_ip_block?
        ip_matchers[@_current_matching_ip_pattern] ||= {}
      end
    end

    # TODO non DRY on handling `@_current_matching_path' !!!! it is terrible!!
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

    def redirect(dest_path, opts={})
      if @_current_matching_path
        path = Regexp.compile("^" + @_current_matching_path.gsub(/\./, '\\.').gsub(/\*/, '.*'))
        current_matchers = detect_matching_pattern
        current_matchers[path] = [:do_redirect, dest_path, opts]
      else
        path '*' do
          redirect dest_path, opts
        end
      end
    end

    def dummy_app(opts={}, &app_proc)
      if @_current_matching_path
        path = Regexp.compile("^" + @_current_matching_path.gsub(/\./, '\\.').gsub(/\*/, '.*'))
        current_matchers = detect_matching_pattern
        current_matchers[path] = [:do_dummy_app, app_proc, opts]
      else
        path '*' do
          dummy_app opts, &app_proc
        end
      end
    end

    alias_method :double, :dummy_app

    private
    def do_halt(req, code, opts={})
      headers = {"Content-Type" => "text/plain"}.merge(opts[:headers] || {})
      body = opts[:body] || "Halt!"
      return [code, headers, [body]]
    end

    def do_redirect(req, dest_path, opts={})
      dest_full_path = case dest_path
                       when /^https?:\/\//
                         dest_path
                       else
                         uri = URI.parse req.url
                         uri.path = dest_path
                         uri.to_s
                       end
      code = opts[:status_code] || 301
      return [code, {"Location" => dest_full_path}, []]
    end

    def do_dummy_app(req, app_proc, opts={})
      case app_proc.arity
      when -1, 0
        return app_proc.call.call(req.env)
      else
        return app_proc.call(req.env)
      end
    end
  end
end
