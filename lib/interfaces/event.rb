# frozen_string_literal: true

require 'low_type'
require 'observers'
require_relative 'definable'
require_relative '../support/value_object'

module Low
  # An event represents what is currently happening in your application.
  #
  # Events are mutable in most cases (except for RenderEvent). They are action-driven, representing inputs and outputs
  # that are currently happening in a linear pipeline-like flow. They are present-tense and one-to-many with one return value.
  # The result of the previous event is made available to the next event. [UNRELEASED]
  #
  # Integrations:
  # - Observers for observer pattern which we wrap in an event-centric API
  # - EventPool for a tree of events and their child events
  # - LowState for state machines to trigger multiple actions [UNLRELEASED]
  class Event
    include LowType
    include Observers
    include Events::Definable
    include Support::ValueObject

    attr_reader :key, :action, :created_at
    attr_accessor :children

    # The subclass will provide the key, usually "self.class".
    def initialize(key:, action: nil, children: [])
      @key = key
      @action = action
      @children = children
      @created_at = Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    end

    def trigger
      event_tree = branch
      key = Observers::Keys[@key]
      key.trigger(event: self) { restore_level(event_tree:) }
    end

    def take
      event_tree = branch
      key = Observers::Keys[@key]
      key.take(event: self) { restore_level(event_tree:) }
    end

    class << self
      def trigger(**kwargs) = new(**kwargs).trigger
      def take(**kwargs) = new(**kwargs).take

      def inherited(child)
        child.include LowType
        increase_count
      end

      def count
        @count ||= 0
      end

      def increase_count
        @count = count + 1
      end
    end

    private

    def branch
      event_tree = Providers['low.event.pool'].current_event_tree(event: self)
      event_tree.branch(event: self)
    end

    def restore_level(event_tree:)
      event_tree.current_event = self if event_tree.respond_to?(:current_event)
    end
  end
end
