# frozen_string_literal: true

require_relative '../../../lib/support/pool_hash'

RSpec.describe Low::Support::PoolHash do
  subject(:pool_hash) { described_class.new(max_size) }

  let(:max_size) { 2 }

  context 'when under max_size' do
    it 'does not yield anything' do
      expect { |block| pool_hash.add(:a, 1, &block) }.not_to yield_control
    end
  end

  context 'when at max_size and adding a new key' do
    before do
      pool_hash.add(:a, 1)
      pool_hash.add(:b, 2)
    end

    it 'evicts the oldest entry' do
      pool_hash.add(:c, 3)

      expect(pool_hash.key?(:a)).to be(false)
      expect(pool_hash.key?(:b)).to be(true)
      expect(pool_hash.key?(:c)).to be(true)
    end

    it 'yields the evicted key and value' do
      expect { |block| pool_hash.add(:c, 3, &block) }.to yield_with_args(:a, 1)
    end
  end

  context 'when at max_size but updating an existing key' do
    before do
      pool_hash.add(:a, 1)
      pool_hash.add(:b, 2)
    end

    it 'does not evict anything' do
      expect { |block| pool_hash.add(:a, 99, &block) }.not_to yield_control
    end
  end
end
