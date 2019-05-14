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
    else
      results[name][1] << time
    end
  end

  Hash[results.map{|name, x|
    [name, x.map{|r| mean(r)} + x.map{|r| variance(r)}]
  }]
end
