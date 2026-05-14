# frozen_string_literal: true

require_relative '../../lib/interfaces/event'

class MockEvent < Low::Event
  attr_reader :request

  def initialize
    super(key: self.class, action: :handle)
  end
end
