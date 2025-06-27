#!/usr/bin/env ruby
require 'json'
require 'diffy'

# Example data - two similar but different hashes
hash1 = {
  name: "John Doe",
  age: 30,
  address: {
    street: "123 Main St",
    city: "New York",
    zip: "10001"
  },
  hobbies: ["reading", "gaming", "hiking"],
  active: true
}

hash2 = {
  name: "John Smith",
  age: 30,
  address: {
    street: "456 Oak Ave",
    city: "New York",
    state: "NY",
    zip: "10002"
  },
  hobbies: ["reading", "swimming", "hiking", "cooking"],
  active: false,
  phone: "555-1234"
}

# Example arrays
array1 = [
  { id: 1, name: "Alice", role: "admin" },
  { id: 2, name: "Bob", role: "user" },
  { id: 3, name: "Charlie", role: "user" }
]

array2 = [
  { id: 1, name: "Alice", role: "superadmin" },
  { id: 2, name: "Robert", role: "user" },
  { id: 4, name: "David", role: "moderator" }
]

def pretty_format(obj)
  # Use JSON.pretty_generate for consistent, clean formatting
  JSON.pretty_generate(JSON.parse(obj.to_json))
end

def generate_html_diff(obj1, obj2, title = "Diff")
  # Convert objects to pretty-printed strings
  str1 = pretty_format(obj1)
  str2 = pretty_format(obj2)
  
  # Create the diff
  diff = Diffy::Diff.new(str1, str2)
  
  # Generate HTML
  html = <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title>#{title}</title>
  <style>
    #{Diffy::CSS}
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f5f5f5;
    }
    h1, h2 {
      color: #333;
    }
    .container {
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      margin-bottom: 20px;
    }
    .diff {
      margin-top: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    pre {
      background-color: #f8f8f8;
      padding: 10px;
      border-radius: 4px;
      overflow-x: auto;
    }
  </style>
</head>
<body>
  <h1>Ruby Object Diff Demo</h1>
  
  <div class="container">
    <h2>#{title}</h2>
    #{diff.to_s(:html)}
  </div>
  
  <div class="container">
    <h2>Original Objects</h2>
    <h3>Object 1:</h3>
    <pre>#{str1}</pre>
    
    <h3>Object 2:</h3>
    <pre>#{str2}</pre>
  </div>
</body>
</html>
  HTML
  
  html
end

# Generate diffs
puts "Generating HTML diffs..."

# Hash diff
File.write("hash_diff.html", generate_html_diff(hash1, hash2, "Hash Diff"))
puts "Created hash_diff.html"

# Array diff
File.write("array_diff.html", generate_html_diff(array1, array2, "Array Diff"))
puts "Created array_diff.html"

# Example with split view
puts "\nGenerating split view diff..."

str1 = pretty_format(hash1)
str2 = pretty_format(hash2)
split_diff = Diffy::SplitDiff.new(str1, str2, format: :html)

split_html = <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title>Split View Diff</title>
  <style>
    #{Diffy::CSS}
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f5f5f5;
    }
    .container {
      display: flex;
      gap: 20px;
    }
    .side {
      flex: 1;
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    h1, h2 {
      color: #333;
    }
    .diff {
      border: 1px solid #ddd;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <h1>Split View Diff</h1>
  
  <div class="container">
    <div class="side">
      <h2>Deletions (Left)</h2>
      #{split_diff.left}
    </div>
    
    <div class="side">
      <h2>Additions (Right)</h2>
      #{split_diff.right}
    </div>
  </div>
</body>
</html>
HTML

File.write("split_diff.html", split_html)
puts "Created split_diff.html"

puts "\nDone! Open the HTML files in your browser to see the diffs."