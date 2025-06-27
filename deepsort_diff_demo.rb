#!/usr/bin/env ruby
require 'json'
require 'diffy'
require 'deepsort'

puts "Testing deepsort gem with mixed key types"
puts "="*60

# Test 1: Mixed key types (symbols, strings, integers)
mixed_keys = {
  :symbol_key => "value1",
  "string_key" => "value2",
  123 => "numeric_key",
  nested: {
    456 => "another_number",
    "z" => 1,
    "a" => 2,
    :b => 3
  }
}

puts "Original hash with mixed keys:"
p mixed_keys

puts "\nAttempting regular sort (will fail):"
begin
  mixed_keys.sort
rescue ArgumentError => e
  puts "Error: #{e.message}"
end

puts "\nUsing deep_sort_by with string conversion:"
sorted = mixed_keys.deep_sort_by { |obj| obj.to_s }
puts JSON.pretty_generate(sorted)

# Test 2: Object diffing with deepsort
puts "\n" + "="*60
puts "Object diffing with deepsort:"
puts "="*60

# Two identical hashes with different key order
hash1 = {
  users: [
    { name: "Alice", age: 25, tags: ["ruby", "python"] },
    { name: "Bob", age: 30, tags: ["javascript", "go"] }
  ],
  config: {
    timeout: 30,
    enabled: true,
    features: { auth: true, cache: false }
  }
}

# Same data, different order
hash2 = {
  config: {
    features: { cache: false, auth: true },
    enabled: true,
    timeout: 30
  },
  users: [
    { tags: ["ruby", "python"], name: "Alice", age: 25 },
    { age: 30, tags: ["javascript", "go"], name: "Bob" }
  ]
}

# Sort both hashes
sorted1 = hash1.deep_sort
sorted2 = hash2.deep_sort

# Convert to JSON and diff
json1 = JSON.pretty_generate(sorted1)
json2 = JSON.pretty_generate(sorted2)

diff = Diffy::Diff.new(json1, json2)
puts "Diff of identical data (should be empty):"
puts diff.to_s(:color)
puts "Are they equal after deep_sort? #{json1 == json2}"

# Test 3: With actual differences
puts "\n" + "="*60
puts "Testing with actual differences:"
puts "="*60

hash3 = hash2.dup
hash3[:config][:timeout] = 60
hash3[:users][0][:age] = 26
hash3[:users] << { name: "Charlie", age: 35, tags: ["rust"] }

sorted3 = hash3.deep_sort
json3 = JSON.pretty_generate(sorted3)

diff_actual = Diffy::Diff.new(json1, json3)
puts "Diff showing only real changes:"
puts diff_actual.to_s(:color)

# Test 4: Mixed key types that could be problematic
puts "\n" + "="*60
puts "Edge case: Arrays with mixed types"
puts "="*60

edge_case = {
  mixed_array: [1, "2", :three, { four: 4 }, [5, "six"]],
  another: ["z", "a", 100, 1]
}

puts "Original:"
p edge_case

puts "\nWith deep_sort_by using string conversion:"
sorted_edge = edge_case.deep_sort_by { |obj| obj.to_s }
puts JSON.pretty_generate(sorted_edge)