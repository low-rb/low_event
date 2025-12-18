# frozen_string_literal: true

require_relative 'low_event'

module Low
  class RenderEvent < LowEvent
    attr_reader :render

    def initialize(action: :render, render: nil)
      super(action:)

      @render = render
    end
  end
end
