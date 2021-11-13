#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3
MAX_FILENAME_LENGTH = 24

def main
  options = retrieve_options
  files = retrieve_files(options)
  number_of_columns = calculate_columns
  number_of_rows = calculate_rows(files, number_of_columns)
  display(files, number_of_rows, number_of_columns)
end

def retrieve_options
  ARGV.getopts('r')
end

def retrieve_files(options)
  if options['r']
    Dir.glob('*').reverse
  else
    Dir.glob('*')
  end
end

def calculate_columns
  number_of_terminal_columns = `tput cols`.to_i
  return MAX_COLUMNS if number_of_terminal_columns > MAX_FILENAME_LENGTH * MAX_COLUMNS

  1.upto(MAX_COLUMNS) do |column|
    break column if number_of_terminal_columns < MAX_FILENAME_LENGTH * (column + 1)
  end
end

def calculate_rows(files, number_of_columns)
  (files.count.to_f / number_of_columns).ceil(0)
end

def display(files, number_of_rows, number_of_columns)
  number_of_rows.times do |row|
    number_of_columns.times do |column|
      index = number_of_rows * column + row
      next unless files[index]

      print files[index].ljust(MAX_FILENAME_LENGTH)
    end
    puts "\n"
  end
end

main
