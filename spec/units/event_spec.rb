# frozen_string_literal: true

require_relative '../fixtures/mock_event.rb'
require_relative '../fixtures/mock_observer.rb'

# An interface that we test via an implementation.
RSpec.describe Low::Event do
  describe '#define' do
    it 'defines observers' do
      MockEvent.define do |observers|
        observers << MockObserver
      end

      expect(Observers[MockEvent]).to include(be_an_instance_of(Observers::Observer))
    end

    context 'with an instance' do
      it 'defines observers' do
        MockEvent.new.define do |observers|
          observers << MockObserver
        end
      end
    end
  end
end
