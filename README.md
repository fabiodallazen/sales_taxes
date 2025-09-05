# Sales Taxes Calculator

## Overview

This is a Ruby application that calculates **sales taxes** and prints receipts for shopping baskets, according to the following rules:

- **Basic sales tax**: 10% on all goods, **except books, food, and medical products** (which are exempt).
- **Import duty**: 5% on all imported goods, with **no exemptions**.
- **Rounding rule**: Taxes are rounded **up** to the nearest 0.05 (five cents).

The application reads a text file with the list of items and outputs a receipt showing:

- Item quantities, names, and prices **including tax**
- Total sales taxes
- Total amount of the basket

This project is built **without any external libraries** (except for RSpec for testing).

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Streaming Support (Memory-Efficient Version)](#streaming-support-memory-efficient-version)
- [Input Format](#input-format)
- [Output Format](#output-format)
- [Example](#example)
- [Project Structure](#project-structure)
- [Rounding Rules](#rounding-rules)
- [Testing](#testing)
- [Assumptions](#assumptions)

---

## Installation

This project was developed and tested with **Ruby 3.2+**.

Ensure you have a compatible version installed before running the application:

1. Clone the repository:

```bash
git clone git@github.com:fabiodallazen/sales_taxes.git
cd sales_taxes
```

2. Install dependencies (RSpec for testing):

```bash
bundle install
```

---

## Usage

Run the application passing the input file as argument:

```bash
ruby main.rb input1.txt
```

The program will parse the items, calculate taxes, and print the receipt to stdout.

---

## Streaming Support (Memory-Efficient Version)

This section describes how the Sales Taxes application handles large input files using **streaming**, ensuring memory usage remains constant regardless of file size.

### How it Works

1. **File Reading**
    - Instead of reading the entire file into memory (`File.readlines`), the application uses `File.foreach`.
    - This reads **one line at a time**, feeding it directly to the parser.
    - Now it's possible to process large files without loading the entire file into memory.

2. **Parsing**
    - Each line is parsed incrementally using `Parser.parse_line`.
    - An Enumerator is used to yield `Item` objects one by one.

3. **Receipt Generation**
    - The `Receipt` class receives an Enumerator of items.
    - It generates receipt lines and accumulates totals **on the fly**, without storing all lines in memory.

4. **Output**
    - The main script iterates over `receipt.lines` and prints each line immediately.

### Example

```ruby
items_enum = parse_file_stream('input.txt')
receipt = Receipt.new(items_enum)
receipt.lines.each { |line| puts line }
```

---
## Input Format

Each line represents one item:

```
<quantity> <product name> at <price>
```

- `quantity`: integer
- `product name`: string, may include "imported"
- `price`: numeric, without currency symbol

**Example:**

```
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
```

---

## Output Format

Receipt lists:

- Each item with quantity, name, and price **including tax**
- Total sales taxes
- Total cost

**Example:**

```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

---

## Example Usage

Input file `input2.txt`:

```
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50
```

Command:

```bash
ruby main.rb input2.txt
```

Output:

```
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15
```

---

## Project Structure

```
.
├── lib
│   ├── item.rb          # Item class
│   ├── parser.rb        # Input line parser
│   ├── rounding.rb      # Tax rounding rules
│   ├── tax_calculator.rb# Tax calculation logic
│   └── receipt.rb       # Receipt generation
├── spec
│   ├── rounding_spec.rb # Tests for rounding
│   └── ...              # Other tests
├── main.rb              # Entry point
├── Gemfile              # Bundler dependencies
└── README.md
```

---

## Rounding Rules

The `Rounding` module ensures **sales taxes are rounded up to the nearest 0.05**, following the challenge requirements:

```ruby
Rounding.round_tax(1.23) # => 1.25
Rounding.round_tax(1.25) # => 1.25
```

- Any value already a multiple of 0.05 remains unchanged.
- Values exceeding a multiple of 0.05 are rounded **up** to the next multiple.

---

## Testing

Run tests using RSpec:

```bash
bundle exec rspec
```

All rounding rules, parsing, and receipt generation are covered.

---

## Assumptions

- Input files are well-formed according to the specified format.
- Only "books", "food", and "medical products" are tax-exempt.
- All imported items include the word "imported" in the name.
- Prices are provided without currency symbols.
- Tax calculations are **rounded up to the nearest 0.05** as per the problem statement.
