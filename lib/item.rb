# frozen_string_literal: true

# Item class
# Purpose: Represents a product in the shopping basket.
#
# Input: quantity (Integer), name (String), price (Float),
#        imported (Boolean), exempt (Boolean).
# Output: An object containing item attributes.
#
# Errors: None. Validation is expected at parsing step.
class Item
  attr_reader :quantity, :name, :price, :imported, :exempt

  def initialize(quantity:, name:, price:, imported: false, exempt: false)
    @quantity = quantity
    @name = name
    @price = price
    @imported = imported
    @exempt = exempt
  end
end
