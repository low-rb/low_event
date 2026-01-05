# frozen_string_literal: true

module Low
  class Event
    include LowType

    attr_reader :action

    def initialize(action: :handle_event)
      @action = action
    end

    def self.inherited(child)
      child.include LowType
    end
  end
end
