#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMNS = 3
MAX_FILENAME_LENGTH = 24

def main
  retrieve
  display
end

def retrieve
  @files = Dir.glob('[^.]*')
  @number_of_files = @files.count
  number_of_terminal_columns = `tput cols`.to_i
  @number_of_columns = if number_of_terminal_columns < MAX_FILENAME_LENGTH * 2
                         1
                       elsif number_of_terminal_columns < MAX_FILENAME_LENGTH * 3
                         2
                       else
                         MAX_COLUMNS
                       end
  @number_of_rows = (@number_of_files.to_f / @number_of_columns).ceil(0)
end

def display
  @number_of_rows.times do |row|
    @number_of_columns.times do |column|
      index = @number_of_rows * column + row
      next unless @files[index]

      print @files[index].ljust(MAX_FILENAME_LENGTH)
      puts "\n" if index >= (@number_of_files - @number_of_rows)
    end
  end
end

main
