# frozen_string_literal: true

# Entry point for the Sales Taxes application.
#
# Usage:
#   ruby main.rb input1.txt
#
# The input file must contain one item per line in the format:
#   "<quantity> <product name> at <price>"
#   - Reads the file line by line, parses items, and prints receipt lines incrementally.
# Output:
#   A printed receipt with all items, sales taxes, and total cost.

require_relative 'lib/item'
require_relative 'lib/parser'
require_relative 'lib/rounding'
require_relative 'lib/tax_calculator'
require_relative 'lib/receipt'

def run(argv)
  file_path = validate_arguments(argv)
  items_enum = parse_file_stream(file_path)
  print_receipt(items_enum)
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

# Reads the input file line by line and yields parsed Item objects.
# Returns an Enumerator, suitable for streaming.
def parse_file_stream(file_path)
  Enumerator.new do |yielder|
    File.foreach(file_path, chomp: true) do |line|
      yielder << Parser.parse_line(line)
    end
  end
end

def print_receipt(items_enum)
  receipt = Receipt.new(items_enum)
  receipt.lines.each { |line| puts line }
end

# Run only if executed directly from terminal
run(ARGV) if __FILE__ == $PROGRAM_NAME
