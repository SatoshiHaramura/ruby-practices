#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, files_name = receive_argument

  files_contents = []
  if files_name.count != 0
    files_contents = files_name.map { |name| File.read(name) }
  else
    files_contents << $stdin.read
  end

  files_info = files_contents.map { |contents| check_file_info(contents) }
  display_files_info(options, files_info, files_name)
  display_total(options, files_info) if files_name.count > 1
end

def receive_argument
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |option| options[:l] = option }
  opt.parse!(ARGV)
  [options, ARGV]
end

def check_file_info(contents)
  {
    lines: contents.lines.count,
    words: contents.split(/\s+/).count,
    bytes: contents.bytesize
  }
end

def display_files_info(options, files, files_name)
  files.each_with_index do |file, i|
    print file[:lines].to_s.rjust(8)
    print file[:words].to_s.rjust(8) unless options[:l]
    print file[:bytes].to_s.rjust(8) unless options[:l]
    print " #{files_name[i]} "
    puts ''
  end
end

def display_total(options, files)
  print files.map { |file| file[:lines] }.sum.to_s.rjust(8)
  print files.map { |file| file[:words] }.sum.to_s.rjust(8) unless options[:l]
  print files.map { |file| file[:bytes] }.sum.to_s.rjust(8) unless options[:l]
  print ' total'
  puts ''
end

main
