# frozen_string_literal: true

module Rubhttp
  class Headers
    # Matches HTTP header names when in "Canonical-Http-Format".
    CANONICAL_NAME_RE = /\A[A-Z][a-z]*(?:-[A-Z][a-z]*)*\z/.freeze

    # Matches valid header field name according to RFC.
    # @see http://tools.ietf.org/html/rfc7230#section-3.2
    COMPLIANT_NAME_RE = /\A[A-Za-z0-9!#\$%&'*+\-.^_`|~]+\z/.freeze

    def initialize
      # The @pile stores each header value using a three element array:
      #
      #   0 - the normalized header key, used for lookup
      #   1 - the header key as it will be sent with a request
      #   2 - the value
      @pile = []
    end

    # Sets header.
    #
    # @param (see #add)
    # @return [void]
    def set(name, value)
      delete(name)
      add(name, value)
    end
    alias []= set

    # Returns list of header values if any.
    #
    # @return [Array<String>]
    def get(name)
      name = normalize_header_name(name.to_s)
      @pile.select { |k, _| k == name }.map { |_, _, v| v }
    end

    # Smart version of {#get}.
    #
    # @return [nil] if header was not set
    # @return [String] if header has exactly one value
    # @return [Array<String>] if header has more than one value
    def [](name)
      values = get(name)
      case values.count
      when 0 then nil
      when 1 then values.first
      else values
      end
    end

    # Appends header.
    #
    # @param [String, Symbol] name header name
    # @param [Array<#to_s>, #to_s] value header value(s) to be appended
    # @return [void]
    def add(name, value)
      lookup_name = normalize_header_name(name.to_s)
      wire_name =
        case name
        when String then name
        when Symbol then lookup_name
        else raise HeaderError, "HTTP header must be a String or Symbol: #{name.inspect}"
        end
      Array(value).each do |v|
        @pile << [lookup_name, wire_name, v.to_s]
      end
    end

    # Removes header.
    #
    # @param [#to_s] name header name
    # @return [void]
    def delete(name)
      name = normalize_header_name(name.to_s)
      @pile.delete_if { |k, _| k == name }
    end

    # Returns Rack-compatible headers Hash.
    #
    # @return [Hash]
    def to_h
      Hash[keys.map { |k| [k, self[k]] }]
    end
    alias to_hash to_h

    # Returns headers key/value pairs.
    #
    # @return [Array<[String, String]>]
    def to_a
      @pile.map { |item| item[1..2] }
    end

    # Returns human-readable representation of `self` instance.
    #
    # @return [String]
    def inspect
      "#<#{self.class} #{to_h.inspect}>"
    end

    # Returns list of header names.
    #
    # @return [Array<String>]
    def keys
      @pile.map { |_, k, _| k }.uniq
    end

    private

    # Transforms `name` to canonical HTTP header capitalization
    #
    # @param [String] name
    # @return [String] canonical HTTP header name
    def normalize_header_name(name)
      return name if name =~ CANONICAL_NAME_RE

      normalized = name.split(/[\-_]/).each(&:capitalize!).join('-')
      return normalized if normalized =~ COMPLIANT_NAME_RE

      raise HeaderError, "Invalid HTTP header field name: #{name.inspect}"
    end
  end
end
