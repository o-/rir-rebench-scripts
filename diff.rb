#!/usr/bin/env ruby

require_relative 'lib'
require 'json'
require 'yaml'
require 'zip'

TOKEN = File.read("token.secret") if File.exists? "token.secret"

def curl(what)
  `curl -L -s --header "PRIVATE-TOKEN: #{TOKEN}" #{what}`
end

URL = "https://gitlab.com/api/v4/projects/10979413"

def fetch(which)
  (id, type) = which.split(",")
  commit = curl("#{URL}/repository/commits/#{id}/statuses?name=benchmark_#{type}_ginger")
  res = JSON.parse(commit)
  res = res.select{|v| v['status'] == 'success'}.last
  job = res['id']
  name = "/tmp/gitlab-artifact-#{job}.zip"
  if !File.exists?(name)
    curl("-o #{name} #{URL}/jobs/#{job}/artifacts")
  end
  Zip::File.open(name) do |io|
    data = io.get_entry("benchmarks.data")
    return data.get_input_stream.read
  end
end

def average(n)
  if n =~ /\d*,.*/
    results = parse(fetch(n))
  elsif File.exists?(n)
    results = read(n)
  else
    puts "No such file #{n}"
    exit 1
  end
  Hash[results.map{|name, x|
    [name, x.map{|r| mean(r)} + x.map{|r| variance(r)}]
  }]
end

c = average(ARGV[0])
b = average(ARGV[1])

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

res = {}
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

  res["#{name} #{speedup_s}\t±#{var_s}\t(#{raw_speedup_s})    \twu: #{c[n][0].round(0)}\tvs. #{t[0].round(0)}"] = speedup
end

res.sort{|x,y| x[1] <=> y[1]}.each do |k,v|
  puts k
end

puts "                                         #{mean(wdiffs).round(2)}\t\t(#{mean(diffs).round(2)})"
