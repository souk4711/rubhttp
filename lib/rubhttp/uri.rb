# frozen_string_literal: true

module Rubhttp
  class Uri
    extend Forwardable

    def_delegators :@uri, :scheme, :normalized_scheme, :scheme=
    def_delegators :@uri, :user, :normalized_user, :user=
    def_delegators :@uri, :password, :normalized_password, :password=
    def_delegators :@uri, :host, :normalized_host, :host=
    def_delegators :@uri, :authority, :normalized_authority, :authority=
    def_delegators :@uri, :origin, :origin=
    def_delegators :@uri, :normalized_port, :port=
    def_delegators :@uri, :path, :normalized_path, :path=
    def_delegators :@uri, :query, :normalized_query, :query=
    def_delegators :@uri, :query_values, :query_values=
    def_delegators :@uri, :request_uri, :request_uri=
    def_delegators :@uri, :fragment, :normalized_fragment, :fragment=
    def_delegators :@uri, :to_s

    def self.parse(uri)
      new(Addressable::URI.parse(uri))
    end

    def initialize(uri)
      @uri = uri
    end

    def inspect
      format('#<%s:0x%014x URI:%s>', self.class.name, object_id << 1, to_s)
    end
  end
end
