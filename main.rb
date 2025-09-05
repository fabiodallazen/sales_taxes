# frozen_string_literal: true

# Entry point for the Sales Taxes application.
#
# Usage:
#   ruby main.rb input1.txt
#
# The input file must contain one item per line in the format:
#   "<quantity> <product name> at <price>"
#
# Output:
#   A printed receipt with all items, sales taxes, and total cost.

require_relative 'lib/item'
require_relative 'lib/parser'
require_relative 'lib/rounding'
require_relative 'lib/tax_calculator'
require_relative 'lib/receipt'

def run(argv)
  file_path = validate_arguments(argv)
  lines = read_file(file_path)
  items = parse_lines(lines)
  print_receipt(items)
rescue ArgumentError => e
  puts "Parsing error: #{e.message}"
  exit(1)
end

def validate_arguments(argv)
  if argv.empty?
    puts 'Usage: ruby main.rb <input_file>'
    exit(1)
  end

  file_path = argv.first
  unless File.exist?(file_path)
    puts "Error: File not found (#{file_path})"
    exit(1)
  end

  file_path
end

def read_file(file_path)
  File.readlines(file_path, chomp: true)
end

def parse_lines(lines)
  lines.map { |line| Parser.parse_line(line) }
end

def print_receipt(items)
  receipt = Receipt.new(items)
  puts receipt.print
end

# Only runs if called directly from the terminal
run(ARGV) if __FILE__ == $PROGRAM_NAME
