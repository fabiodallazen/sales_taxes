# frozen_string_literal: true

require_relative 'tax_calculator'

# Receipt class
# Purpose: Generate a receipt string for a basket of items
#
# Input: Array of Item objects
# Output: Formatted receipt string including item totals, sales taxes, and total amount
class Receipt
  attr_reader :items

  def initialize(items)
    @items = items
  end

  # Generate receipt string
  def print
    total_taxes = 0.0
    total_amount = 0.0

    lines = items.map do |item|
      line, item_tax, item_total = process_item(item)
      total_taxes += item_tax
      total_amount += item_total
      line
    end

    lines + formatted_totals(total_taxes, total_amount)
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

  def formatted_totals(total_taxes, total_amount)
    [
      "Sales Taxes: #{format_amount(total_taxes)}",
      "Total: #{format_amount(total_amount)}"
    ]
  end

  def format_amount(amount)
    format('%.2f', amount)
  end
end
