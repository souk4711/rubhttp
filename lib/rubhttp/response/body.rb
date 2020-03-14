# frozen_string_literal: true

module Rubhttp
  class Response
    class Body
      # @param contents [String]
      def initialize(contents)
        @contents = contents.freeze
      end

      # @return [String] the entire body as a string
      def to_s
        @contents
      end
      alias to_str to_s

      # Easier to interpret string inspect.
      def inspect
        "#<#{self.class}:#{object_id.to_s(16)}>"
      end
    end
  end
end
