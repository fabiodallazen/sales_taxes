# frozen_string_literal: true

require_relative 'rounding'

# TaxCalculator class
# Purpose: Calculate taxes for items according to rules (basic sales tax + import duty)
#
# Input: Item object
# Output: Total tax for the item (float)
#
# Errors: Assumes the item object is valid.
class TaxCalculator
  BASIC_TAX_RATE = 0.10
  IMPORT_TAX_RATE = 0.05

  def self.calculate(item)
    tax_rate = 0.0
    tax_rate += BASIC_TAX_RATE unless item.exempt
    tax_rate += IMPORT_TAX_RATE if item.imported

    # Calculate tax per unit first, then multiply by quantity
    tax_per_unit = Rounding.round_tax(item.price * tax_rate)
    tax_per_unit * item.quantity
  end
end
