# frozen_string_literal: true

# Standard libraries
require 'forwardable'

# Third party libraries
require 'addressable/uri'
require 'http'

# Rubhttp
require 'rubhttp/errors'

module Rubhttp
  autoload :VERSION, 'rubhttp/version'
  autoload :Adapter, 'rubhttp/adapter'
  autoload :Client, 'rubhttp/client'
  autoload :Headers, 'rubhttp/headers'
  autoload :Middleware, 'rubhttp/middleware'
  autoload :RackBuilder, 'rubhttp/rack_builder'
  autoload :Request, 'rubhttp/request'
  autoload :Response, 'rubhttp/response'
  autoload :Uri, 'rubhttp/uri'

  module Adapters
    autoload :HTTP, 'rubhttp/adapters/http'
  end

  class Request
    autoload :Body, 'rubhttp/request/body'
  end

  class Response
    autoload :Body, 'rubhttp/response/body'
    autoload :Status, 'rubhttp/response/status'
  end
end
