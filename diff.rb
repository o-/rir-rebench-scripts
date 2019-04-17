#!/usr/bin/env ruby

require 'bigdecimal'

# https://stackoverflow.com/a/14744502
def gmean(xs)
  one = BigDecimal.new 1
  xs.map { |x| BigDecimal.new x }.inject(one, :*) ** (one / xs.size)
end

WARMUP = 3

def sum_up(results)
  (results.map{|r| Float(r)}.inject(:+) / results.size).to_i
end

def read(f)
  data = File.read(f).split("\n").reject{|l| l =~ /#.*/}
  results = {}
  data.each do |line|
    d = line.split("\t")
    name = d[5]
    time = d[2]
    iter = Integer(d[1])
    exit 1 unless d[3] == "ms"
    results[name] ||= [[],[]]
    if iter > WARMUP
      results[name][0] << time
    end
    results[name][1] << time
  end

  Hash[results.map{|name, x|
    [name, x.map{|r| sum_up(r)}]
  }]
end

c = read(ARGV[0])
b = read(ARGV[1])

wdiffs = []
diffs = []

b.each do |n, t|
  name = n
  (40-name.length).times{ name+= " " }

  speedup = BigDecimal(t[0])/BigDecimal(c[n][0])
  raw_speedup = BigDecimal(t[1])/BigDecimal(c[n][1])

  wdiffs << speedup
  diffs << raw_speedup

  puts "#{name} #{speedup.round(2).to_s('F')}\t(#{raw_speedup.round(2).to_s('F')})    \twu: #{t[0]}\tvs. #{c[n][0]}"
end

puts "                                         #{gmean(wdiffs).round(2).to_s('F')}\t(#{gmean(diffs).round(2).to_s('F')})"
