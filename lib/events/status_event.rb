# frozen_string_literal: true

require_relative '../interfaces/event'

module Low
  module Events
    class StatusEvent < Event
      attr_reader :status, :request

      def initialize(status:, request:, action: :render)
        super(key: status, action:)

        @status = status
        @request = request
      end
    end
  end
end
