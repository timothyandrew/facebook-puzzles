#!/usr/bin/ruby

class Array
  # Returns the "power set" for this Array. This means that an array with all
  # subsets of the array's elements will be returned.
  def power
    # the power set line is stolen from http://johncarrino.net/blog/2006/08/11/powerset-in-ruby/
    inject([[]]){|c,y|r=[];c.each{|i|r<<i;r<<i+[y]};r}
  end
end


lines = IO.readlines(ARGV[0])
size = lines[0].to_i

last_dna_line = size/80
if size%80 != 0
  last_dna_line = size/80+1
end

num_triples = lines[last_dna_line+1].to_i
triples = Array.new

for i in last_dna_line+2..num_triples + last_dna_line + 1
  lines[i] =~ /(\d+)\s+(\d+)\s+(\d+)/
  triples.push([$1.to_i, $2.to_i, $3.to_i])
end

all_triples = triples.power
valid_triples = Array.new

for triple_combo in all_triples
  if triple_combo.length == 0
    next
  end
  
  range = Array.new
  for triple in triple_combo    
    for i in triple[0]..triple[1]
      range.push(i)
    end
  end
  
  if range.uniq == range
    valid_triples.push(triple_combo)
  end
end

scores = Array.new
for triple_combo in valid_triples
  score = 0
  for triple in triple_combo
    score += triple[2]
  end
  scores.push(score)
end

puts scores.max
  