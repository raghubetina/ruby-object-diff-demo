#!/usr/bin/env ruby
require 'json'
require 'diffy'
require 'deepsort'

# Test showing why array order matters
puts "Why array order matters:"
puts "="*60

obj1 = {
  steps: ["wash", "rinse", "repeat"],
  scores: [100, 85, 92],
  users: [
    { name: "Alice", rank: 1 },
    { name: "Bob", rank: 2 },
    { name: "Charlie", rank: 3 }
  ]
}

obj2 = {
  users: [
    { rank: 1, name: "Alice" },  # Same user, different key order
    { rank: 2, name: "Bob" },
    { rank: 3, name: "Charlie" }
  ],
  steps: ["wash", "rinse", "repeat"],  # Same array
  scores: [100, 85, 92]
}

obj3 = {
  users: [
    { rank: 2, name: "Bob" },     # Different order - Bob is first!
    { rank: 1, name: "Alice" },
    { rank: 3, name: "Charlie" }
  ],
  steps: ["rinse", "wash", "repeat"],  # Different order - semantically different!
  scores: [85, 100, 92]  # Different order - different meaning!
}

puts "obj1 and obj2 should be equal (only hash keys differ)"
puts "obj1 and obj3 should be different (array order differs)"

puts "\nUsing deep_sort (sorts everything):"
diff1 = Diffy::Diff.new(
  JSON.pretty_generate(obj1.deep_sort),
  JSON.pretty_generate(obj2.deep_sort)
)
puts "obj1 vs obj2: #{diff1.to_s(:color).strip.empty? ? 'EQUAL' : 'DIFFERENT'}"

diff2 = Diffy::Diff.new(
  JSON.pretty_generate(obj1.deep_sort),
  JSON.pretty_generate(obj3.deep_sort)
)
puts "obj1 vs obj3: #{diff2.to_s(:color).strip.empty? ? 'EQUAL (WRONG!)' : 'DIFFERENT'}"

puts "\nUsing deep_sort(array: false) - preserves array order:"
diff3 = Diffy::Diff.new(
  JSON.pretty_generate(obj1.deep_sort(array: false)),
  JSON.pretty_generate(obj2.deep_sort(array: false))
)
puts "obj1 vs obj2: #{diff3.to_s(:color).strip.empty? ? 'EQUAL' : 'DIFFERENT'}"

diff4 = Diffy::Diff.new(
  JSON.pretty_generate(obj1.deep_sort(array: false)),
  JSON.pretty_generate(obj3.deep_sort(array: false))
)
puts "obj1 vs obj3: #{diff4.to_s(:color).strip.empty? ? 'EQUAL' : 'DIFFERENT (CORRECT!)'}"

puts "\nShowing the actual diff for obj1 vs obj3:"
puts diff4.to_s(:color)