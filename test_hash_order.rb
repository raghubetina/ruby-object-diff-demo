#!/usr/bin/env ruby
require 'json'
require 'diffy'

# Test case: Same content, different order
hash_a = { foo: 1, bar: 2 }
hash_b = { bar: 2, foo: 1 }

puts "Are the hashes equal in Ruby? #{hash_a == hash_b}"
puts

# Convert to pretty JSON strings
str_a = JSON.pretty_generate(hash_a)
str_b = JSON.pretty_generate(hash_b)

puts "Hash A JSON:"
puts str_a
puts "\nHash B JSON:"
puts str_b

# Create diff
diff = Diffy::Diff.new(str_a, str_b)
puts "\nDiff output:"
puts diff.to_s(:color)

# To fix this, we could deep sort the keys
def deep_sort_hash(obj)
  case obj
  when Hash
    obj.sort.to_h.transform_values { |v| deep_sort_hash(v) }
  when Array
    obj.map { |v| deep_sort_hash(v) }
  else
    obj
  end
end

puts "\n" + "="*50
puts "With deep sorting:"
puts "="*50

sorted_a = deep_sort_hash(hash_a)
sorted_b = deep_sort_hash(hash_b)

str_sorted_a = JSON.pretty_generate(sorted_a)
str_sorted_b = JSON.pretty_generate(sorted_b)

diff_sorted = Diffy::Diff.new(str_sorted_a, str_sorted_b)
puts "Diff output after sorting:"
puts diff_sorted.to_s(:color)
puts "\nAre they the same after sorting? #{str_sorted_a == str_sorted_b}"