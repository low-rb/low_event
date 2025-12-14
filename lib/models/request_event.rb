# frozen_string_literal: true

require_relative 'low_event'

module Low
  class RequestEvent < LowEvent
    attr_reader :request

    def initialize(request:)
      @request = request
    end
  end
end
