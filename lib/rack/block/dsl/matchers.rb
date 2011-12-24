require 'rack/block/dsl/builtin_bot_pattern'
module Rack::Block::DSL
  module Matchers
    def bot_access(&block)
      ua_pattern BUILTIN_BOT_PATTERN, &block      
    end

    # TODO it's NO DRY
    def ua_pattern(pattern, &block)
      @_current_matching_type, orig = :by_UA, @_current_matching_type
      @_current_matching_ua_pattern, orig_ptn = pattern, @_current_matching_ua_pattern
      yield
    ensure
      @_current_matching_ua_pattern = orig_ptn
      @_current_matching_type = orig
    end

    def ip_pattern(pattern, &block)
      @_current_matching_type, orig = :by_IP, @_current_matching_type
      @_current_matching_ip_pattern, orig_ptn = ip_to_pattern(pattern), @_current_matching_ip_pattern
      yield
    ensure
      @_current_matching_ip_pattern = orig_ptn
      @_current_matching_type = orig
    end

    alias block_ua ua_pattern
    alias block_ip ip_pattern

    def path(pattern, &block)
      @_current_matching_path, orig = pattern, @_current_matching_path
      yield
    ensure
      @_current_matching_path = orig
    end

    private
    def ip_to_pattern(ip_pattern)
      case ip_pattern
      when /^(\d+)(\.\d+){3}$/
        Regexp.compile("^" + ip_pattern.gsub('.', '\\.') + "$")
      when /^(\d+)(\.\d+){0,2}\.?$/
        ip_pattern = ip_pattern.sub(/\.$/, '')
        Regexp.compile("^" + ip_pattern.gsub('.', '\\.') + '(\\.\\d+)+' + "$")
      else
        raise ArgumentError, 'passed invalid IP string'
      end
    end

    def in_ua_block?
      @_current_matching_type == :by_UA
    end

    def in_ip_block?
      @_current_matching_type == :by_IP
    end
  end
end
