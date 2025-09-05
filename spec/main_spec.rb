# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Main script integration' do
  let(:bin) { File.expand_path('../main.rb', __dir__) }
  let(:fixtures) { File.expand_path('fixtures', __dir__) }

  def run_main(file)
    `ruby #{bin} #{file}`
  end

  context 'when processing valid input files' do
    it 'processes input1.txt correctly' do
      output = run_main("#{fixtures}/input1.txt")
      aggregate_failures do
        expect(output).to include('2 book: 24.98')
        expect(output).to include('1 music CD: 16.49')
        expect(output).to include('1 chocolate bar: 0.85')
        expect(output).to include('Sales Taxes: 1.50')
        expect(output).to include('Total: 42.32')
      end
    end

    it 'processes input2.txt correctly' do
      output = run_main("#{fixtures}/input2.txt")
      aggregate_failures do
        expect(output).to include('1 imported box of chocolates: 10.50')
        expect(output).to include('1 imported bottle of perfume: 54.65')
        expect(output).to include('Sales Taxes: 7.65')
        expect(output).to include('Total: 65.15')
      end
    end

    it 'processes input3.txt correctly' do
      output = run_main("#{fixtures}/input3.txt")
      aggregate_failures do
        expect(output).to include('1 imported bottle of perfume: 32.19')
        expect(output).to include('1 bottle of perfume: 20.89')
        expect(output).to include('1 packet of headache pills: 9.75')
        expect(output).to include('3 imported boxes of chocolates: 35.55')
        expect(output).to include('Sales Taxes: 7.90')
        expect(output).to include('Total: 98.38')
      end
    end

    it 'processes input_mixed.txt correctly (all cases in one file)' do
      output = run_main("#{fixtures}/input_mixed.txt")
      aggregate_failures do
        expect(output).to include('1 book: 12.49')
        expect(output).to include('1 music CD: 16.49')
        expect(output).to include('1 chocolate bar: 0.85')
        expect(output).to include('1 imported bottle of perfume: 32.19')
        expect(output).to include('1 packet of headache pills: 9.75')
        expect(output).to include('2 imported boxes of chocolates: 23.70')
        expect(output).to include('Sales Taxes: 6.90')
        expect(output).to include('Total: 95.47')
      end
    end
  end

  context 'when processing invalid input files' do
    it 'raises error for invalid_missing_at.txt' do
      output = run_main("#{fixtures}/invalid_missing_at.txt")
      expect(output).to include("Parsing error: Invalid format: missing 'at' separator in line '1 book 12.49'")
    end

    it 'raises error for invalid_quantity.txt' do
      output = run_main("#{fixtures}/invalid_quantity.txt")
      expect(output).to include("Parsing error: Invalid quantity 'x' in line 'x music CD at 14.99'")
    end

    it 'raises error for invalid_price.txt' do
      output = run_main("#{fixtures}/invalid_price.txt")
      expect(output).to include("Parsing error: Invalid price '12,49' in line '1 book at 12,49'")
    end

    it 'raises error for non-existent file' do
      output = `ruby #{bin} #{fixtures}/does_not_exist.txt`
      expect(output).to include('Error: File not found')
    end
  end
end
# rubocop:enable RSpec/DescribeClass
