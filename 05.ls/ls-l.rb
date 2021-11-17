#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMNS = 3
MAX_FILENAME_LENGTH = 24

def main
  files_name = retrieve_files
  if retrieve_options['l']
    files_info, length, block_size = retrieve_files_info(files_name)
    display_files_info(files_info, length, block_size)
  else
    number_of_columns = calculate_columns
    number_of_rows = calculate_rows(files_name, number_of_columns)
    display(files_name, number_of_rows, number_of_columns)
  end
end

def retrieve_files
  Dir.glob('*')
end

def retrieve_options
  ARGV.getopts('l')
end

# def retrieve_files_info
def retrieve_files_info(files_name)
  files = Hash.new { |h, k| h[k] = {} }
  length = { link: 0, owner: 0, group: 0, size: 0 }
  block_size = 0

  files_name.each do |name|
    file_stat = File.lstat(name)

    block_size += file_stat.blocks
    files[name][:type] = check_type(name)
    files[name][:permission] = check_permission(file_stat)
    files[name][:link] = file_stat.nlink.to_s
    files[name][:owner] = Etc.getpwuid(file_stat.uid).name
    files[name][:group] = Etc.getgrgid(file_stat.gid).name
    files[name][:size] = file_stat.size.to_s
    files[name][:month] = file_stat.mtime.month.to_s
    files[name][:day] = file_stat.mtime.day.to_s
    files[name][:time] = file_stat.mtime.strftime('%H:%M').to_s

    length = check_length(files, name, length)
  end
  [files, length, block_size]
end

def check_type(file)
  type = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }
  type[File.ftype(file)]
end

def check_permission(file_stat)
  permission = ''
  3.times do |i|
    case file_stat.mode.to_s(8)[-3 + i]
    when '0' then permission += '---'
    when '1' then permission += '--x'
    when '2' then permission += '-w-'
    when '3' then permission += '-wx'
    when '4' then permission += 'r--'
    when '5' then permission += 'r-x'
    when '6' then permission += 'rw-'
    when '7' then permission += 'rwx'
    end
  end
  permission = check_setuid(permission) if file_stat.setuid?
  permission = check_setgid(permission) if file_stat.setgid?
  permission = check_sticky(permission) if file_stat.sticky?
  permission
end

def check_setuid(permission)
  permission[2] = permission[2] == 'x' ? 's' : 'S'
  permission
end

def check_setgid(permission)
  permission[5] = permission[5] == 'x' ? 's' : 'S'
  permission
end

def check_sticky(permission)
  permission[8] = permission[8] == 'x' ? 't' : 'T'
  permission
end

def check_length(files, name, length)
  length[:link] = files[name][:link].length if length[:link] < files[name][:link].length
  length[:owner] = files[name][:owner].length if length[:owner] < files[name][:owner].length
  length[:group] = files[name][:group].length if length[:group] < files[name][:group].length
  length[:size] = files[name][:size].length if length[:size] < files[name][:size].length
  length
end

def display_files_info(files, length, block_size)
  puts "total #{block_size}"
  Dir.glob('*') do |name|
    print files[name][:type]
    print "#{files[name][:permission]} "
    print "#{files[name][:link].rjust(length[:link] + 1)} "
    print "#{files[name][:owner].ljust(length[:owner])}  "
    print "#{files[name][:group].ljust(length[:group])} "
    print "#{files[name][:size].rjust(length[:size] + 1)} "
    print "#{files[name][:month].rjust(2)} "
    print "#{files[name][:day].rjust(2)} "
    print "#{files[name][:time]} "
    print files[name][:type] == 'l' ? export_symlink_name(name) : name
    puts ''
  end
end

def export_symlink_name(name)
  "#{name} -> #{File.readlink(name)}"
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
