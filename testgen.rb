#!/usr/bin/env ruby

def usage
  print <<EOS

usage: ruby testgencharg.rb <num>

  this will output test-<num>.csv which is sample data for genchart.rb

EOS
end

num = ARGV.shift.to_i

File.open("test-#{num}.csv", "w") do |f|
  0.upto(num) do |n|
    f.write "#{rand(1000)},\n"
  end
end
