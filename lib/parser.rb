# frozen_string_literal: true

require_relative 'item'

# Parser class
# Purpose: Parse shopping basket lines into Item objects.
#
# Input: String in the format "quantity product_name at price".
# Output: Item object with parsed attributes.
#
# Errors:
#   - ArgumentError if quantity is invalid.
#   - ArgumentError if product name is missing.
#   - ArgumentError if price format is invalid.
class Parser
  def self.parse_line(line)
    quantity, name, price = parsed_values_from(line)

    Item.new(
      quantity: quantity,
      name: name,
      price: price,
      imported: imported_item?(name),
      exempt: tax_exempt?(name)
    )
  end

  # Extracts and validates each component from the line
  # Returns: [quantity (Integer), name (String), price (Float)]
  def self.parsed_values_from(line)
    quantity_str, name_str, price_str = split_values(line)

    [
      validate_quantity!(quantity_str, line),
      validate_name!(name_str, line),
      validate_price!(price_str, line)
    ]
  end

  # Splits a line into quantity, product name, and price
  # Input: "2 imported box of chocolates at 10.00"
  # Output: ["2", "imported box of chocolates", "10.00"]
  # Note: Does not validate the components, only extracts them
  def self.split_values(line)
    raise ArgumentError, "Invalid format: missing 'at' separator in line '#{line}'" unless line.include?(' at ')

    # Regex groups:
    #   ^(\S+)   -> quantity (non-space characters)
    #   \s+(.+)  -> product name (anything until " at ")
    #   \s+at\s+(.+) -> price (anything after "at")
    line.match(/^(\S+)\s+(.+)\s+at\s+(.+)$/).captures
  end

  def self.validate_quantity!(quantity_str, line)
    # /^\d+$/ -> validates if the quantity is a positive integer
    raise ArgumentError, "Invalid quantity '#{quantity_str}' in line '#{line}'" unless quantity_str =~ /^\d+$/

    quantity_str.to_i
  end

  def self.validate_name!(name_str, line)
    raise ArgumentError, "Missing product name in line '#{line}'" if name_str.nil? || name_str.strip.empty?

    name_str
  end

  def self.validate_price!(price_str, line)
    # /^\d+\.\d{2}$/ -> validates if the price is in the correct format with two decimal places
    raise ArgumentError, "Invalid price '#{price_str}' in line '#{line}'" unless price_str =~ /^\d+\.\d{2}$/

    price_str.to_f
  end

  def self.tax_exempt?(name)
    %w[book chocolate chocolates pills].any? { |word| name.include?(word) }
  end

  def self.imported_item?(name)
    name.include?('imported')
  end
end
