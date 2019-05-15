#!/usr/bin/env ruby

require_relative 'lib'

b = read(ARGV[0])

b.keys.sort.each do |n|
  t = b[n]
  name = n

  puts t.inspect
  next

  t[0].each do |r|
    puts "#{name}, #{r}"
  end
end
