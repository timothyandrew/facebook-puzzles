#!/usr/bin/ruby

class Node
  attr_writer :targets
  attr_reader :targets
  attr_reader :name
  # targets -> array of nodes
  # name -> node name
  def initialize(name)
    @targets = Array.new
    @name = name
    @color = nil
  end
end

$x = Array.new
$y = Array.new

$first = true
def traverse(root)
  if $first
    $x.push(root.name)
    $first = false
  end
  
  if root.targets.empty?
    return
  end
  
  root.targets.each do |target|
    if $x.include?(target.name) or $y.include?(target.name)
      return
    end
    if $x.include?(root.name)
      $y.push(target.name)
    elsif $y.include?(root.name)
      $x.push(target.name)
    end
       
    traverse(target) 
  end
end

if(ARGV.length != 1)
  puts 'Usage: ./liarliar.rb <filename>'
  Process.exit
end

lines = IO.readlines(ARGV[0])

#Clean up lines
for i in 0...lines.length
  if lines[i][-1].chr == "\n"
    lines[i] = lines[i].delete "\n"
  end
end

size = lines.shift

# Create nodes
i = 0
nodes = Hash.new
target_names = Hash.new
while i<lines.length
  if lines[i] =~ /(\w+)\s+(\d)/
    nodes[$~[1]] = Node.new($~[1])
    target_names[$~[1]] = Array.new
    1.upto($~[2].to_i) do |x|
      target_names[$~[1]].push(lines[i+x])
    end
      i += $~[2].to_i + 1 
  end
end

for name,node in nodes
  for target_name in target_names[name]
    node.targets.push(nodes[target_name])
  end
end


#Find node with highest degree
largest = 0
largest_node = nil
for target_name, targets in target_names
  if targets.length > largest
    largest = targets.length
    largest_node = nodes[target_name]
  end
end

#Split up the nodes (graph coloring)
traverse(largest_node)

puts [$x.length,$y.length].max.to_s + ' ' + [$x.length,$y.length].min.to_s