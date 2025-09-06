# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Parser do
  subject(:parser) { described_class }

  it 'parses a valid line correctly', :aggregate_failures do
    item = parser.parse_line('1 imported box of chocolates at 10.00')
    expect(item.quantity).to eq(1)
    expect(item.name).to eq('imported box of chocolates')
    expect(item.price).to eq(10.00)
    expect(item.imported).to be true
    expect(item.exempt).to be true
  end

  it "raises error for missing 'at' separator" do
    expect { parser.parse_line('1 book 12.49') }.to raise_error(ArgumentError)
  end

  it 'raises error for invalid quantity' do
    expect { parser.parse_line('x book at 12.49') }.to raise_error(ArgumentError)
  end

  it 'raises error for invalid price' do
    expect { parser.parse_line('1 book at 12,49') }.to raise_error(ArgumentError)
  end
end
