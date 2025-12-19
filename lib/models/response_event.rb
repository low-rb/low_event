# frozen_string_literal: true

require_relative 'low_event'

module Low
  class ResponseEvent < Event
    attr_reader :body

    def initialize(body: nil)
      @body = body
    end
  end
end
