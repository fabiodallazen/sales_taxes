# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rounding do
  describe '.round_tax' do
    it 'rounds up to nearest 0.05', :aggregate_failures do
      expect(described_class.round_tax(1.21)).to eq(1.25)
      expect(described_class.round_tax(1.23)).to eq(1.25)
      expect(described_class.round_tax(1.25)).to eq(1.25)
      expect(described_class.round_tax(1.26)).to eq(1.30)
      expect(described_class.round_tax(0.01)).to eq(0.05)
      expect(described_class.round_tax(0.00)).to eq(0.00)
      expect(described_class.round_tax(0.049)).to eq(0.05)
      expect(described_class.round_tax(0.051)).to eq(0.10)
      expect(described_class.round_tax(10.00)).to eq(10.00)
      expect(described_class.round_tax(10.01)).to eq(10.05)
    end
  end
end
