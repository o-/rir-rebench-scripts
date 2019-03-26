#!/bin/env ruby

require 'bigdecimal'

# https://stackoverflow.com/a/14744502
def gmean(xs)
  one = BigDecimal.new 1
  xs.map { |x| BigDecimal.new x }.inject(one, :*) ** (one / xs.size)
end

def read(f)
  Hash[File.read(f).split("\n").map{|l| l=l.split(", "); l[1] = Integer(l[1]); l }]
end

b = read('/tmp/baseline.csv')
c = read('/tmp/compare.csv')

diffs = []

b.each do |n, t|
  speedup = BigDecimal(t)/BigDecimal(c[n])
  name = n
  (40-name.length).times{ name+= " " }
  puts "#{name} #{speedup.round(2).to_s('F')}"
  diffs << speedup
end

puts gmean(diffs).round(2).to_s('F')
