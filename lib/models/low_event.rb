# frozen_string_literal: true

module Low
  class LowEvent
    attr_reader :action

    def intialize(action:)
      @action = action
    end
  end
end
