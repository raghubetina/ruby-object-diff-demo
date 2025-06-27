# Ruby Object Diff Demo

A proof-of-concept for generating beautiful HTML diffs between Ruby hashes and arrays using the [diffy](https://github.com/samg/diffy) gem and [deepsort](https://github.com/mcrossen/deepsort) gem for robust object comparison.

## Split View Diff Example

![Split View Diff](split_diff.png)

## Overview

This demo shows how to:
- Convert Ruby objects (hashes, arrays) to nicely formatted JSON strings
- Handle hash key ordering issues (two hashes with same content but different key order)
- Support mixed key types (symbols, strings, integers)
- Preserve array order (since array order is semantically meaningful)
- Generate visual diffs with character-level highlighting
- Create HTML output suitable for web display
- Support multiple diff formats (text, colored terminal, HTML)

## Examples

### Hash Diff
```ruby
hash1 = { name: "John Doe", age: 30, city: "New York" }
hash2 = { name: "John Smith", age: 30, city: "Boston" }
```

Produces a visual diff highlighting:
- Name change from "Doe" to "Smith" 
- City change from "New York" to "Boston"

### Array Diff
```ruby
array1 = [{ id: 1, status: "active" }, { id: 2, status: "pending" }]
array2 = [{ id: 1, status: "inactive" }, { id: 3, status: "active" }]
```

Shows additions, deletions, and modifications in array elements.

## Files

- `html_diff_poc.rb` - Main proof-of-concept script that generates HTML files
- `simple_diff_demo.rb` - Console demo showing different output formats
- `object_differ.rb` - Robust object comparison class that handles key ordering
- `deepsort_diff_demo.rb` - Demo showing deepsort gem capabilities
- `test_hash_order.rb` - Test showing the hash ordering problem and solution
- `array_order_test.rb` - Demo showing why array order preservation matters
- `hash_diff.html` - Example HTML diff between two hashes
- `array_diff.html` - Example HTML diff between two arrays
- `split_diff.html` - Split view diff (deletions on left, additions on right)

## Usage

### Basic Usage (Original Approach)

```ruby
require 'json'
require 'diffy'

# Your Ruby objects
obj1 = { name: "Alice", skills: ["Ruby", "Python"] }
obj2 = { name: "Alice", skills: ["Ruby", "Python", "JavaScript"] }

# Convert to pretty JSON
str1 = JSON.pretty_generate(obj1)
str2 = JSON.pretty_generate(obj2)

# Create diff
diff = Diffy::Diff.new(str1, str2)

# Generate HTML
html_output = diff.to_s(:html)
```

### Robust Usage with ObjectDiffer (Handles Key Ordering)

```ruby
require_relative 'object_differ'

# These hashes are identical but have different key order
hash1 = { foo: 1, bar: 2, nested: { x: 10, y: 20 } }
hash2 = { bar: 2, nested: { y: 20, x: 10 }, foo: 1 }

# Check equality
ObjectDiffer.equal?(hash1, hash2)  # => true

# Generate diff (will be empty since they're equal)
diff = ObjectDiffer.diff(hash1, hash2)

# With actual differences
hash3 = { bar: 3, nested: { y: 20, x: 10 }, foo: 1 }
diff = ObjectDiffer.diff(hash1, hash3, format: :html)
```

### Key Ordering Problem and Solution

```ruby
# Problem: These identical hashes appear different with naive approach
a = { foo: 1, bar: 2 }
b = { bar: 2, foo: 1 }

# Naive approach shows difference (incorrect!)
diff = Diffy::Diff.new(
  JSON.pretty_generate(a),
  JSON.pretty_generate(b)
)

# Solution: Use deepsort gem
require 'deepsort'
sorted_a = a.deep_sort(array: false)  # Don't sort arrays
sorted_b = b.deep_sort(array: false)
# Now they'll compare as equal
```

### Running the Demos

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Generate HTML diff files:
   ```bash
   ruby html_diff_poc.rb
   ```
   Then open `hash_diff.html`, `array_diff.html`, or `split_diff.html` in your browser.

3. See console output with different formats:
   ```bash
   ruby simple_diff_demo.rb
   ```

4. Test the hash ordering problem and solution:
   ```bash
   ruby test_hash_order.rb
   ```

5. See why array order matters:
   ```bash
   ruby array_order_test.rb
   ```

6. Try the ObjectDiffer class:
   ```bash
   ruby object_differ.rb
   ```

## Output Formats

### Text Format
```
 {
   "name": "Alice",
-  "age": 25,
+  "age": 26,
   "skills": [
     "Ruby",
-    "Python"
+    "Python",
+    "JavaScript"
   ]
 }
```

### HTML Format
- Red highlighting for deletions
- Green highlighting for additions
- Character-level diff highlighting within changed lines
- Clean, styled output with CSS

### Terminal Color Format
- ANSI colored output for command-line viewing
- Red for deletions, green for additions

## Integration Ideas

This approach could be integrated into:
- RSpec test output for better failure messages
- API response comparisons
- Configuration file change tracking
- Database record change visualization
- Git-style diff viewers for Ruby objects

## Requirements

- Ruby 2.0+
- diffy gem (~> 3.4)
- deepsort gem (~> 0.4)
- JSON standard library

## License

This is a proof-of-concept demo. The diffy gem is copyright Sam Goldstein and contributors.
