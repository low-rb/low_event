# frozen_string_literal: true

require 'observers'

require_relative '../events/request_event'
require_relative 'event_tree'
require_relative '../support/pool_hash'

module Low
  module Events
    class EventPool
      include Observers

      BUFFER_SIZE = 100

      def initialize
        @pool = Support::PoolHash.new(BUFFER_SIZE)
        @request_counts = Support::PoolHash.new(BUFFER_SIZE)
      end

      def current_event_tree(event:)
        request_id = request_id(event:)

        return @pool[request_id] if @pool[request_id]

        event_tree = @pool.add(request_id, EventTree.new(request_id:)) do |_evicted_request_id, evicted_tree|
          # Without this, an evicted EventTree can never be garbage collected: EventTree#branch
          # observes itself via Observers::Keys[self], and Keys never removes entries on its own,
          # so every request's EventTree (and everything it references -- Request, Response,
          # child events) would otherwise be retained for the life of the process.
          Observers::Keys.keys.delete(evicted_tree)
        end
        trigger action: :new_event_tree, event: event_tree

        event_tree
      end

      def event_trees
        @pool
      end

      private

      def request_id(event:)
        fiber_id = Fiber.current.object_id
        increment_request_counts(fiber_id:) if event.is_a?(RequestEvent)
        "#{fiber_id}-#{@request_counts[fiber_id]}"
      end

      def increment_request_counts(fiber_id:)
        @request_counts[fiber_id] ||= 0
        @request_counts[fiber_id] += 1
      end
    end
  end
end
