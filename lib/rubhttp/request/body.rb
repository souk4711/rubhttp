# frozen_string_literal: true

module Rubhttp
  class Request
    # @api private
    #
    # NOTE: This class is a subject of future refactoring, thus don't
    #   expect this class API to be stable until this message disappears and
    #   class is not marked as private anymore.
    class Body
      attr_reader :contents

      # @option contents [String, IO] :body
      # @option contents [Hash] :form
      # @option contents [Hash] :json
      def initialize(contents)
        @contents = contents
      end
    end
  end
end
