# frozen_string_literal: true

require 'low_type'

class LowEvent
  include LowType

  attr_reader :action

  def intialize(action: Symbol | String)
    @action = action
  end
end
