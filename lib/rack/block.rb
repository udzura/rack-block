require 'rack'
module Rack
  class Block
    require 'rack/block/dsl'

    include DSL::Matchers
    include DSL::Responses

    def initialize(app, &b)
      @_current_matching_type       = nil
      @_current_matching_ua_pattern = nil
      @_current_matching_ip_pattern = nil
      @_current_matching_path       = nil
      @ua_matchers = {}
      @ip_matchers = {}
      instance_eval(&b)
      @app = app
    end
    
    attr_reader :app
    attr_accessor :ua_matchers, :ip_matchers
    
    def call(env)
      req = Rack::Request.new(env)
      self.ua_matchers.each_pair do |pattern, path_matchers|
        if pattern =~ req.user_agent
          path_matchers.each_pair do |path, action_with_args|
            if path =~ req.path_info
              action, *args = action_with_args
              return send action, req, *args
            end
          end
        end
      end

      self.ip_matchers.each_pair do |pattern, path_matchers|
        if pattern =~ req.ip
          path_matchers.each_pair do |path, action_with_args|
            if path =~ req.path_info
              action, *args = action_with_args
              return send action, req, *args
            end
          end
        end
      end

      app.call(env)
    end
    # Your code goes here...
  end
end

require "rack/block/version"
