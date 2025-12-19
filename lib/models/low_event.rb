# frozen_string_literal: true

module Low
  class Event
    attr_reader :action

    def initialize(action: :handle_event)
      @action = action
    end
  end
end
