# frozen_string_literal: true

require_relative '../../../lib/pool/event_pool'
require_relative '../../../lib/events/request_event'
require_relative '../../../lib/events/response_event'

RSpec.describe Low::Events::EventPool do
  subject(:event_pool) { described_class.new }

  after { Observers::Keys.reset }

  def request_event(fiber_id:)
    allow(Fiber).to receive(:current).and_return(instance_double(Fiber, object_id: fiber_id))
    Low::Events::RequestEvent.new(request: nil)
  end

  def response_event(fiber_id:)
    allow(Fiber).to receive(:current).and_return(instance_double(Fiber, object_id: fiber_id))
    Low::Events::ResponseEvent.new
  end

  describe '#current_event_tree' do
    it 'returns the same tree for later events on the same request (e.g. its eventual response)' do
      request_tree = event_pool.current_event_tree(event: request_event(fiber_id: 1))
      response_tree = event_pool.current_event_tree(event: response_event(fiber_id: 1))

      expect(response_tree).to equal(request_tree)
    end

    it 'returns a new tree for each new request on the same fiber' do
      first_request_tree = event_pool.current_event_tree(event: request_event(fiber_id: 1))
      second_request_tree = event_pool.current_event_tree(event: request_event(fiber_id: 1))

      expect(second_request_tree).not_to equal(first_request_tree)
    end

    it 'returns a different tree for a different request' do
      first_tree = event_pool.current_event_tree(event: request_event(fiber_id: 1))
      second_tree = event_pool.current_event_tree(event: request_event(fiber_id: 2))

      expect(first_tree).not_to equal(second_tree)
    end
  end

  describe 'evicting old event trees' do
    # EventTree#branch registers the tree itself as an Observers::Keys entry (via `trigger`,
    # which every LowEvent#trigger/#take calls). Observers::Keys never removes entries on its
    # own, so an evicted-but-still-registered EventTree can never be garbage collected --
    # this is the regression this test guards against.
    it 'removes the evicted tree from Observers::Keys so it can be garbage collected' do
      first_event = request_event(fiber_id: 1)
      first_tree = event_pool.current_event_tree(event: first_event)
      first_tree.branch(event: first_event) # Registers first_tree with Observers::Keys.

      expect(Observers::Keys.keys.key?(first_tree)).to be(true)

      # Fill the pool past its buffer size so the first tree gets evicted.
      (2..(described_class::BUFFER_SIZE + 1)).each do |fiber_id|
        event_pool.current_event_tree(event: request_event(fiber_id:))
      end

      expect(Observers::Keys.keys.key?(first_tree)).to be(false)
    end

    it 'does not affect trees still within the buffer' do
      recent_event = request_event(fiber_id: 1)
      recent_tree = event_pool.current_event_tree(event: recent_event)
      recent_tree.branch(event: recent_event)

      (2..described_class::BUFFER_SIZE).each do |fiber_id|
        event_pool.current_event_tree(event: request_event(fiber_id:))
      end

      expect(Observers::Keys.keys.key?(recent_tree)).to be(true)
    end
  end
end
