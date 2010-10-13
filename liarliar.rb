#!/usr/bin/ruby

class Node
  attr_writer :targets
  attr_reader :targets
  attr_writer :color
  attr_reader :color
  attr_reader :name
  # targets -> array of nodes
  # name -> node name
  def initialize(name)
    @targets = Array.new
    @name = name
    @color = nil
  end
end

$x = Array.new #color red
$y = Array.new #color blue

$first = true
def traverse(root)
  if $first
    root.color = 'red'
    $first = false
  end
  
  if root.targets.empty?
    return
  end
  
  root.targets.each do |target|
    if target.color
       if root.color == nil
         # If target has already been selected
         if target.color == 'blue'
           root.color = 'red'
         elsif target.color == 'red'
           root.color = 'blue'
         end
       end
       return
    end
    #If root has already been selected
    if root.color == 'red'
      target.color = 'blue'
    elsif root.color == 'blue'
      target.color = 'red'
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

lines.shift

# Create nodes
i = 0
nodes = Hash.new
target_names = Hash.new
while i<lines.length
  if lines[i] =~ /(\w+)\s+(\d)/
    nodes[$~[1]] = Node.new($~[1])
    target_names[$~[1]] = Array.new
    if $~[2] == 0
      next
    end
    1.upto($~[2].to_i) do |x|
      target_names[$~[1]].push(lines[i+x])
    end
      i += $~[2].to_i + 1 
  end
end

# Set Targets for all the nodes.
# (Somewhat equal to drawing edges between vertices)
for name,node in nodes
  for target_name in target_names[name]
    node.targets.push(nodes[target_name])
  end
end


# Split up the nodes 3 passes
3.times do
  for name, node in nodes
    traverse(node)
  end
end

# Final Pass
l1 = 0
l2 = 0
for name, node in nodes
  traverse(node)
  
  if node.color == 'red'
    l1 += 1
  elsif node.color == 'blue'
    l2 += 1
  elsif node.color == nil
    puts "Error!!"
  end
end


puts [l1,l2].max.to_s + ' ' + [l1,l2].min.to_s