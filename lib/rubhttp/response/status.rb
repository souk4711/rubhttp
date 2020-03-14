# frozen_string_literal: true

module Rubhttp
  class Response
    class Status
      REASONS = {
        100 => 'Continue',
        101 => 'Switching Protocols',
        102 => 'Processing',
        200 => 'OK',
        201 => 'Created',
        202 => 'Accepted',
        203 => 'Non-Authoritative Information',
        204 => 'No Content',
        205 => 'Reset Content',
        206 => 'Partial Content',
        207 => 'Multi-Status',
        208 => 'Already Reported',
        226 => 'IM Used',
        300 => 'Multiple Choices',
        301 => 'Moved Permanently',
        302 => 'Found',
        303 => 'See Other',
        304 => 'Not Modified',
        305 => 'Use Proxy',
        307 => 'Temporary Redirect',
        308 => 'Permanent Redirect',
        400 => 'Bad Request',
        401 => 'Unauthorized',
        402 => 'Payment Required',
        403 => 'Forbidden',
        404 => 'Not Found',
        405 => 'Method Not Allowed',
        406 => 'Not Acceptable',
        407 => 'Proxy Authentication Required',
        408 => 'Request Timeout',
        409 => 'Conflict',
        410 => 'Gone',
        411 => 'Length Required',
        412 => 'Precondition Failed',
        413 => 'Payload Too Large',
        414 => 'URI Too Long',
        415 => 'Unsupported Media Type',
        416 => 'Range Not Satisfiable',
        417 => 'Expectation Failed',
        421 => 'Misdirected Request',
        422 => 'Unprocessable Entity',
        423 => 'Locked',
        424 => 'Failed Dependency',
        426 => 'Upgrade Required',
        428 => 'Precondition Required',
        429 => 'Too Many Requests',
        431 => 'Request Header Fields Too Large',
        451 => 'Unavailable For Legal Reasons',
        500 => 'Internal Server Error',
        501 => 'Not Implemented',
        502 => 'Bad Gateway',
        503 => 'Service Unavailable',
        504 => 'Gateway Timeout',
        505 => 'HTTP Version Not Supported',
        506 => 'Variant Also Negotiates',
        507 => 'Insufficient Storage',
        508 => 'Loop Detected',
        510 => 'Not Extended',
        511 => 'Network Authentication Required'
      }.each_value(&:freeze).freeze

      # @return [Fixnum] status code
      attr_reader :code

      # @param code [Fixnum]
      def initialize(code)
        @code = code
      end

      # @see REASONS
      # @return [String, nil] status message
      def reason
        REASONS[code]
      end

      # Check if status code is informational (1XX).
      #
      # @return [Boolean]
      def informational?
        code >= 100 && code < 200
      end

      # Check if status code is successful (2XX).
      #
      # @return [Boolean]
      def success?
        code >= 200 && code < 300
      end

      # Check if status code is redirection (3XX).
      #
      # @return [Boolean]
      def redirect?
        code >= 300 && code < 400
      end

      # Check if status code is client error (4XX).
      #
      # @return [Boolean]
      def client_error?
        code >= 400 && code < 500
      end

      # Check if status code is server error (5XX).
      #
      # @return [Boolean]
      def server_error?
        code >= 500 && code < 600
      end

      # @return [String] string representation of HTTP status
      def to_s
        "#{code} #{reason}".strip
      end

      # Printable version of HTTP Status, surrounded by quote marks,
      # with special characters escaped.
      #
      # @return [String]
      def inspect
        "#<#{self.class} #{self}>"
      end
    end
  end
end
