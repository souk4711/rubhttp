# frozen_string_literal: true

module Rubhttp
  class Middleware
    attr_reader :app

    def initialize(app = nil)
      @app = app
    end

    def call(_request)
      raise "#{self.class}#call(request) is unimplemented"
    end
  end
end
