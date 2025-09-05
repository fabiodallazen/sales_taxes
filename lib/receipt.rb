# frozen_string_literal: true

require_relative 'tax_calculator'

# Receipt class (streaming-ready)
#
# Purpose:
#   Generates a receipt for a basket of items without storing all lines in memory.
#   Designed for large datasets, memory-efficient and SOLID-compliant.
#
# Usage:
#   receipt = Receipt.new(items_enum)
#   receipt.lines.each { |line| puts line }
#
# Notes:
#   - Items are passed as an Enumerator or any object that responds to #each.
#   - Taxes and totals are accumulated internally.
#   - Responsibility: Only generate formatted lines; does NOT perform output.
class Receipt
  def initialize(items_enum)
    @items = items_enum
  end

  # Returns an enumerator that yields receipt lines incrementally
  #
  # Output:
  #   Enumerator yielding strings formatted as:
  #     "<quantity> <item_name>: <price_with_tax>"
  #   After all items, yields totals:
  #     "Sales Taxes: <total_taxes>"
  #     "Total: <total_amount>"
  def lines
    Enumerator.new do |yielder|
      total_taxes = 0.0
      total_amount = 0.0

      @items.each do |item|
        line, item_tax, item_total = process_item(item)
        total_taxes += item_tax
        total_amount += item_total
        yielder << line
      end

      yielder << "Sales Taxes: #{format_amount(total_taxes)}"
      yielder << "Total: #{format_amount(total_amount)}"
    end
  end

  private

  def process_item(item)
    item_tax = TaxCalculator.calculate(item)
    item_total = total_price(item, item_tax)
    [formatted_item_line(item, item_total), item_tax, item_total]
  end

  def total_price(item, tax)
    (item.price * item.quantity) + tax
  end

  def formatted_item_line(item, total)
    "#{item.quantity} #{item.name}: #{format_amount(total)}"
  end

  def format_amount(amount)
    format('%.2f', amount)
  end
end
