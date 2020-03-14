# frozen_string_literal: true

module Rubhttp
  class Response
    extend Forwardable

    # @return [Status]
    attr_reader :status

    # @return [Headers]
    attr_reader :headers

    # @return [Body]
    attr_reader :body

    def_delegator :@status, :code
    def_delegator :@status, :reason

    # @option options [Integer] :status
    # @option options [Hash] :headers
    # @option options [String] :body
    def initialize(options)
      status = options.fetch(:status)
      headers = options[:headers] || {}
      body = options[:body] || ''

      @status = build_response_status(status)
      @headers = build_response_headers(headers)
      @body = build_response_body(body)
    end

    private

    def build_response_status(status)
      Status.new(status)
    end

    def build_response_headers(headers)
      response_headers = Headers.new
      headers.each { |k, v| response_headers[k] = v }
      response_headers
    end

    def build_response_body(body)
      Body.new(body)
    end
  end
end
