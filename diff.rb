#!/bin/env ruby

def read(f)
  Hash[File.read(f).split("\n").map{|l| l=l.split(", "); l[1] = Integer(l[1]); l }]
end

b = read('/tmp/baseline.csv')
c = read('/tmp/compare.csv')

diffs = []

b.each do |n, t|
  speedup = Float(t)/Float(c[n])
  name = n
  (40-name.length).times{ name+= " " }
  puts "#{name} #{speedup.round(2)}"
  diffs << speedup
end

puts (diffs.inject(:+) / diffs.length).round(2)
