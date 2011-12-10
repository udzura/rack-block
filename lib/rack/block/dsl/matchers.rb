module Rack::Block::DSL
  module Matchers
    BUILTIN_BOT_PATTERN = /googlebot/i

    def bot_access(&block)
      ua_pattern BUILTIN_BOT_PATTERN, &block      
    end

    def ua_pattern(pattern, &block)
      @_current_matching_type, orig = :by_UA, @_current_matching_type
      @_current_matching_ua_pattern, orig_ptn = pattern, @_current_matching_ua_pattern
      yield
    ensure
      @_current_matching_ua_pattern = orig_ptn
      @_current_matching_type = orig
    end

    def path(pattern, &block)
      @_current_matching_path, orig = pattern, @_current_matching_path
      yield
    ensure
      @_current_matching_path = orig
    end
  end
end
