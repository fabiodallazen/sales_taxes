# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TaxCalculator do
  subject(:tax_calculator) { described_class }

  it 'does not apply tax on books' do
    item = Item.new(quantity: 1, name: 'book', price: 12.49, exempt: true)
    expect(tax_calculator.calculate(item)).to eq(0.0)
  end

  it 'applies 10% tax on music CD' do
    item = Item.new(quantity: 1, name: 'music CD', price: 14.99)
    expect(tax_calculator.calculate(item)).to eq(1.50)
  end

  it 'applies 5% import tax' do
    item = Item.new(quantity: 1, name: 'imported chocolate', price: 10.00, imported: true, exempt: true)
    expect(tax_calculator.calculate(item)).to eq(0.50)
  end
end
