# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Receipt do
  it 'liness receipt correctly', :aggregate_failures do
    items = [
      Parser.parse_line('2 book at 12.49'),
      Parser.parse_line('1 music CD at 14.99'),
      Parser.parse_line('1 chocolate bar at 0.85')
    ]
    receipt = described_class.new(items)
    output = receipt.lines

    expect(output).to include('2 book: 24.98')
    expect(output).to include('1 music CD: 16.49')
    expect(output).to include('1 chocolate bar: 0.85')
    expect(output).to include('Sales Taxes: 1.50')
    expect(output).to include('Total: 42.32')
  end
end
