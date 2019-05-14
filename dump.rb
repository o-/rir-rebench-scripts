#!/usr/bin/env ruby

require_relative 'lib'

b = read(ARGV[0])

b.keys.sort.each do |n|
  t = b[n]
  name = n

  var = (t[2]).round(0)

  puts "#{name}, #{t[0].round(0)}, #{var}"
end
