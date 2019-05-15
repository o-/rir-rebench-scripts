#!/usr/bin/env ruby

require_relative 'lib'

b = read(ARGV[0])

b.keys.sort.each do |n|
  t = b[n]
  name = n

  t[1].each do |r|
    puts "#{name}, #{r}"
  end
end
