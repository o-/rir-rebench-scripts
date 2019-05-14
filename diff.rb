#!/usr/bin/env ruby

require_relative 'lib'

c = read(ARGV[0])
b = read(ARGV[1])

wdiffs = []
diffs = []

def format_number(speedup)
  speedup_s = speedup.round(2).to_s()

  diff = (speedup-1).abs
  if diff > 0.1
      speedup_s = speedup_s.bold
  end

  speedup_s = if speedup >= 1.04
    speedup_s.green
  elsif speedup <= 0.96
    speedup_s.red
  elsif diff <= 0.02
    speedup_s.gray
  else
    speedup_s
  end
end

b.keys.sort.each do |n|
  next if !c[n].is_a? Array
  t = b[n]
  name = n
  (40-name.length).times{ name+= " " }

  speedup = t[0]/c[n][0]
  raw_speedup = t[1]/c[n][1]

  wdiffs << speedup
  diffs << raw_speedup

  speedup_s = format_number(speedup)
  raw_speedup_s = format_number(raw_speedup)

  var = ((t[2]).round(0))
  var_s =
    if var > 10
      var.to_s.red
    elsif var < 3
      var.to_s.gray
    else
      var.to_s
    end
  (3-var.to_s.length).times{ var_s += " "}

  puts "#{name} #{speedup_s}\t±#{var_s}\t(#{raw_speedup_s})    \twu: #{c[n][0].round(0)}\tvs. #{t[0].round(0)}"
end

puts "                                         #{mean(wdiffs).round(2)}\t\t(#{mean(diffs).round(2)})"
