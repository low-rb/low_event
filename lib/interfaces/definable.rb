# frozen_string_literal: true

module Low
  module Events
    module Definable
      def define(key = self)
        yield observers(key)
      end

      class << self
        def included(klass)
          klass.extend Definable
        end
      end
    end
  end
end
