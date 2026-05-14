# frozen_string_literal: true

require_relative '../interfaces/event'

module Low
  module Events
    class RequestEvent < Event
      attr_reader :request

      def initialize(request:, action: :handle)
        super(key: self.class, action:)

        @request = request
      end
    end
  end
end
