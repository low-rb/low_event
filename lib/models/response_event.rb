# frozen_string_literal: true

require_relative 'low_event'

module Low
  class ResponseEvent < LowEvent
    attr_reader :response

    def initialize(response: nil)
      @response = response
    end
  end
end
