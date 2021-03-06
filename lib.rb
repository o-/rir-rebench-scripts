#!/usr/bin/env ruby

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  def bold;           "\e[1m#{self}\e[22m" end
end

WARMUP = 5

def mean(results)
  results.map{|r| Float(r)}.inject(:+) / results.size
end

def variance(results)
  m = mean(results)
  Math.sqrt(mean(results.map{|r| v = Float(r)-m; v*v}))
end

def read(f)
  data = File.read(f)
  parse(data)
end

def parse(data)
  data = data.split("\n").reject{|l| l =~ /#.*/}
  results = {}
  data.each do |line|
    d = line.split("\t")
    name = "#{d[5]} #{d[7]}"
    time = d[2]
    iter = Integer(d[1])
    next unless d[3] == "ms"
    results[name] ||= [[],[]]
    if iter > WARMUP
      results[name][0] << time
    else
      results[name][1] << time
    end
  end

  results
end
