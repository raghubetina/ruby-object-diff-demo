#!/usr/bin/env ruby
require 'json'
require 'diffy'

# Simple example
hash1 = {
  name: "Alice",
  age: 25,
  skills: ["Ruby", "Python"]
}

hash2 = {
  name: "Alice",
  age: 26,
  skills: ["Ruby", "Python", "JavaScript"],
  location: "NYC"
}

# Convert to pretty JSON strings
str1 = JSON.pretty_generate(hash1)
str2 = JSON.pretty_generate(hash2)

puts "Original Hash 1:"
puts str1
puts "\nOriginal Hash 2:"
puts str2

# Create and display text diff
puts "\n" + "="*50
puts "Text Diff:"
puts "="*50
diff = Diffy::Diff.new(str1, str2)
puts diff.to_s(:text)

# Create and display color diff (for terminal)
puts "\n" + "="*50
puts "Color Diff (for terminal):"
puts "="*50
puts diff.to_s(:color)

# Show the HTML output
puts "\n" + "="*50
puts "HTML Output (view source):"
puts "="*50
puts diff.to_s(:html)