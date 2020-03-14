# frozen_string_literal: true

module Rubhttp
  # Generic error
  Error = Class.new(StandardError)

  # Generic Connection error
  ConnectionError = Class.new(Error)

  # Generic Timeout error
  TimeoutError = Class.new(Error)

  # Header value is of unexpected format (similar to Net::HTTPHeaderSyntaxError)
  HeaderError = Class.new(Error)
end
