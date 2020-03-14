# frozen_string_literal: true

module Rubhttp
  class Request
    # @return [String]
    attr_reader :verb

    # @return [Uri]
    attr_reader :uri

    # @return [Headers]
    attr_reader :headers

    # @return [Body]
    attr_reader :body

    # @option options [#to_s] :verb
    # @option options [String] :uri
    # @option options [Hash] :params
    # @option options [Hash] :headers
    # @option options [String, IO] :body
    # @option options [Hash] :form
    # @option options [Hash] :json
    def initialize(options)
      verb = options.fetch(:verb).to_s
      uri = options.fetch(:uri)
      params = options[:params] || {}
      headers = options[:headers] || {}
      body = options.slice(:body, :form, :json)

      @verb = verb.downcase.to_sym
      @uri = build_request_uri(uri, params)
      @headers = build_request_headers(headers)
      @body = build_request_body(body)
    end

    # Returns human-readable representation of `self` instance.
    #
    # @return [String]
    def inspect
      "#<#{self.class} #{verb.to_s.upcase} #{uri}>"
    end

    private

    def build_request_uri(uri, params)
      request_uri = Uri.parse(uri)
      request_uri.query_values = request_uri.query_values(Array).to_a.concat(params.to_a) unless params.empty?
      request_uri.path = '/' if request_uri.path.empty?
      request_uri
    end

    def build_request_headers(headers)
      request_headers = Headers.new
      headers.each { |k, v| request_headers[k] = v }
      request_headers
    end

    def build_request_body(body)
      Body.new(body)
    end
  end
end
