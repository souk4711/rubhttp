# frozen_string_literal: true

module Rubhttp
  module Adapters
    class HTTP < Adapter
      def call(request)
        verb = request.verb
        uri = request.uri.to_s
        headers = request.headers.to_h
        body = request.body.contents
        r = make_http_request(verb, uri, headers, body)

        status = r.code
        headers = r.headers.to_h
        body = r.body.to_s
        Response.new(status: status, headers: headers, body: body)
      end

      private

      def make_http_request(verb, uri, headers, body)
        ::HTTP.headers(headers).public_send(verb, uri, body)
      rescue ::HTTP::TimeoutError => e
        raise TimeoutError, e.message
      rescue ::HTTP::ConnectionError => e
        raise ConnectionError, e.message
      rescue StandardError => e
        raise Error, e.message
      end
    end
  end
end
