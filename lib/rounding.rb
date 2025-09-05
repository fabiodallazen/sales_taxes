# frozen_string_literal: true

# Rounding module
# Purpose: Provides rounding rules specifically for sales tax calculations.
#
# Sales tax amounts must be rounded **up** to the nearest 0.05 (five cents),
# according to the problem statement. This ensures that the tax is never undercharged.
#
# This implementation uses a simple, readable approach:
# 1. Calculate the remainder of the amount modulo 0.05.
# 2. If the remainder is zero, the amount is already a multiple of 0.05.
# 3. Otherwise, add the difference (0.05 - remainder) to round up to the next multiple of 0.05.
# 4. Round the final result to 2 decimal places for monetary representation.
#
# Example:
#   Rounding.round_tax(1.23) => 1.25
#   Rounding.round_tax(1.25) => 1.25
module Rounding
  def self.round_tax(amount)
    remainder = amount % 0.05
    result = remainder.zero? ? amount : amount + (0.05 - remainder)
    result.round(2)
  end
end
