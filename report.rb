#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require './lib/parser'

output = $stdout

options = OpenStruct.new(
  input: [],
  output: '-',
)

OptionParser.new do |opt|
  opt.on('-i', '--input FILENAME') { |o| options.input += [o] }
  opt.on('-o', '--output FILENAME', '-') { |o| options.output = o }
end.parse!


parser = Lib::Parser.new

streams = options.input.map do |input|
  return $stdout if input == '-'
  File.open input
end

streams.each do |stream|
  parser.parse stream
end

doc = parser.document.reports.each do |_, report|
  output.puts "Report #{report.id} Overall Score: #{report.score}"
  report.tracks.each do |_, track|
    output.puts "Track T1 Score: #{track.score}"
  end
end
