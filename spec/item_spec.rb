# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Item do
  let(:item) { described_class.new(quantity: 2, name: 'book', price: 12.49, imported: false, exempt: true) }

  it 'stores the quantity correctly' do
    expect(item.quantity).to eq(2)
  end

  it 'stores the name correctly' do
    expect(item.name).to eq('book')
  end

  it 'stores the price correctly' do
    expect(item.price).to eq(12.49)
  end

  it 'stores the imported flag correctly' do
    expect(item.imported).to be(false)
  end

  it 'stores the exempt flag correctly' do
    expect(item.exempt).to be(true)
  end
end
