#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, files = receive_argument
  if files.count != 0
    files_info = check_files_info(files)
    display_files_info(options, files_info)
    display_total(options, files_info) if files.count > 1
  else
    stdin = $stdin.read
    stdin_info = check_stdin_info(stdin)
    display_stdin_info(options, stdin_info)
  end
end

def receive_argument
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |option| options[:l] = option }
  opt.parse!(ARGV)
  [options, ARGV]
end

def check_files_info(files)
  files.map do |file|
    hash = {}
    hash[:name] = file
    f = File.read(file)
    hash[:lines] = f.lines.count
    hash[:words] = f.split(/\s+/).count
    hash[:bytes] = f.bytesize
    hash
  end
end

def check_stdin_info(stdin)
  hash = {}
  hash[:lines] = stdin.lines.count
  hash[:words] = stdin.split(/\s+/).count
  hash[:bytes] = stdin.bytesize
  hash
end

def display_files_info(options, files)
  files.each do |file|
    print file[:lines].to_s.rjust(8)
    print file[:words].to_s.rjust(8) unless options[:l]
    print file[:bytes].to_s.rjust(8) unless options[:l]
    print " #{file[:name]} "
    puts ''
  end
end

def display_total(options, files)
  print files.inject { |result, item| result[:lines] + item[:lines] }.to_s.rjust(8)
  print files.inject { |result, item| result[:words] + item[:words] }.to_s.rjust(8) unless options[:l]
  print files.inject { |result, item| result[:bytes] + item[:bytes] }.to_s.rjust(8) unless options[:l]
  print ' total'
  puts ''
end

def display_stdin_info(options, stdin)
  print stdin[:lines].to_s.rjust(8)
  print stdin[:words].to_s.rjust(8) unless options[:l]
  print stdin[:bytes].to_s.rjust(8) unless options[:l]
  puts ''
end

main
