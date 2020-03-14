# frozen_string_literal: true

module Rubhttp
  class RackBuilder
    LockedError = Class.new(StandardError)

    attr_reader :adapter

    def self.app(&block)
      builder = new
      block.call(builder) if block_given?
      builder.app
    end

    def initialize
      @adapter = nil
      @middlewares = []
    end

    def use(middleware, *args, &block)
      raise_error_if_locked
      @middlewares << proc { |app| middleware.new(app, *args, &block) }
    end

    def app
      @app ||= begin
        lock!
        to_app
      end
    end

    private

    def lock!
      @middlewares.freeze
    end

    def locked?
      @middlewares.frozen?
    end

    def raise_error_if_locked
      raise LockedError, "can't modify middleware stack after app created" if locked?
    end

    def default_adapter
      Adapters::HTTP.new
    end

    def to_app
      @adapter = default_adapter if @adapter.nil?
      @adapter.freeze
      @middlewares.reverse.inject(@adapter) { |a, e| e[a].tap(&:freeze) }
    end
  end
end
