# frozen_string_literal: true

module Low
  module Support
    class PoolHash < Hash
      def initialize(max_size)
        @max_size = max_size

        super()
      end

      def add(key, value)
        # Prune the hash when a new item added.
        if size >= @max_size && !key?(key)
          evicted_key, evicted_value = shift
          yield(evicted_key, evicted_value) if block_given?
        end

        self[key] = value
      end
    end
  end
end
