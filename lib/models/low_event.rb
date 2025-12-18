# frozen_string_literal: true

module Low
  class LowEvent
    attr_reader :action

    def initialize(action: :handle_event)
      @action = action
    end
  end
end
