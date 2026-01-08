# frozen_string_literal: true

require 'protocol/http'
require_relative 'low_event'

module Low
  module Events
    class ResponseEvent < Event
      attr_reader :response

      # TODO: Type: "response: Protocol::HTTP::Response"
      def initialize(response: nil)
        @response = response
      end
    end
  end
end
