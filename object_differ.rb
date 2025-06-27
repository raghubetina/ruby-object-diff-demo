#!/usr/bin/env ruby
require 'json'
require 'diffy'
require 'deepsort'

class ObjectDiffer
  def self.diff(obj1, obj2, format: :color)
    # Normalize both objects using deep_sort
    normalized1 = normalize_object(obj1)
    normalized2 = normalize_object(obj2)
    
    # Convert to pretty JSON
    json1 = JSON.pretty_generate(normalized1)
    json2 = JSON.pretty_generate(normalized2)
    
    # Create and return diff
    Diffy::Diff.new(json1, json2).to_s(format)
  end
  
  def self.equal?(obj1, obj2)
    normalized1 = normalize_object(obj1)
    normalized2 = normalize_object(obj2)
    
    JSON.pretty_generate(normalized1) == JSON.pretty_generate(normalized2)
  end
  
  private
  
  def self.normalize_object(obj)
    # Sort hash keys but preserve array order
    # Use deep_sort_by with string conversion to handle mixed key types
    obj.deep_sort_by(array: false) { |item| item.to_s }
  end
end

# Example usage
if __FILE__ == $0
  puts "ObjectDiffer Examples"
  puts "="*60
  
  # Example 1: Same hash, different order
  hash_a = { foo: 1, bar: 2, baz: { x: 10, y: 20 } }
  hash_b = { bar: 2, baz: { y: 20, x: 10 }, foo: 1 }
  
  puts "Example 1: Same content, different order"
  puts "Are they equal? #{ObjectDiffer.equal?(hash_a, hash_b)}"
  puts "Diff output:"
  puts ObjectDiffer.diff(hash_a, hash_b)
  
  # Example 2: With actual differences
  hash_c = { bar: 3, baz: { y: 20, x: 10, z: 30 }, foo: 1 }
  
  puts "\nExample 2: Actual differences"
  puts "Are they equal? #{ObjectDiffer.equal?(hash_a, hash_c)}"
  puts "Diff output:"
  puts ObjectDiffer.diff(hash_a, hash_c)
  
  # Example 3: Mixed key types
  mixed_a = { :sym => 1, "str" => 2, 123 => 3 }
  mixed_b = { "str" => 2, 123 => 3, :sym => 1 }
  
  puts "\nExample 3: Mixed key types"
  puts "Are they equal? #{ObjectDiffer.equal?(mixed_a, mixed_b)}"
  puts "Diff output:"
  puts ObjectDiffer.diff(mixed_a, mixed_b)
  
  # Example 4: HTML output
  puts "\nExample 4: HTML format"
  puts ObjectDiffer.diff(hash_a, hash_c, format: :html)
end