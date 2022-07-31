#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require './lib/parser'

options = OpenStruct.new(
  inputs: [],
  output: $stdout,
)

OptionParser.new do |opt|
  opt.on('-i', '--input FILENAME') do |filename|
    options.inputs += [filename == '-' ? $stdin : File.open(filename)]
  end

  opt.on('-o', '--output FILENAME') do |filename|
    options.output = File.open(filename, File::CREAT|File::WRONLY)
  end
end.parse!


parser = Lib::Parser.new

options.inputs.each do |input|
  parser.parse input
end

parser.document.generate_report(options.output)
