#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMNS = 3
FILENAME_LENGTH_UNIT = 8

def main
  options = retrieve_options
  files_name = retrieve_files(options)
  filename_length = check_filename_length(files_name)
  max_filename_length = calculate_max_filename_length(filename_length)
  if options['l']
    files_info, length, block_size = retrieve_files_info(files_name)
    display_files_info(files_info, length, block_size)
  else
    number_of_columns = calculate_columns(max_filename_length)
    number_of_rows = calculate_rows(files_name, number_of_columns)
    display(files_name, number_of_rows, number_of_columns, max_filename_length)
  end
end

def retrieve_options
  ARGV.getopts('arl')
end

def retrieve_files(options)
  if options['a'] && options['r']
    Dir.glob('*', File::FNM_DOTMATCH).reverse
  elsif options['a']
    Dir.glob('*', File::FNM_DOTMATCH)
  elsif options['r']
    Dir.glob('*').reverse
  else
    Dir.glob('*')
  end
end

def check_filename_length(files_name)
  name_length = 0
  files_name.each do |name|
    name_length = name.length if name_length < name.length
  end
  name_length
end

def calculate_max_filename_length(filename_length)
  FILENAME_LENGTH_UNIT * ((filename_length / FILENAME_LENGTH_UNIT) + 1)
end

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
  permission = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rx-',
    '7' => 'rwx'
  }
  permissions = ''
  3.times do |i|
    permissions += permission[file_stat.mode.to_s(8)[-3 + i]]
  end
  permissions = check_setuid(permissions) if file_stat.setuid?
  permissions = check_setgid(permissions) if file_stat.setgid?
  permissions = check_sticky(permissions) if file_stat.sticky?
  permissions
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
  files.each_value do |file|
    print file[:type]
    print "#{file[:permission]} "
    print "#{file[:link].rjust(length[:link] + 1)} "
    print "#{file[:owner].ljust(length[:owner])}  "
    print "#{file[:group].ljust(length[:group])} "
    print "#{file[:size].rjust(length[:size] + 1)} "
    print "#{file[:month].rjust(2)} "
    print "#{file[:day].rjust(2)} "
    print "#{file[:time]} "
    print file[:type] == 'l' ? export_symlink_name(files.key(file)) : files.key(file)
    puts ''
  end
end

def export_symlink_name(name)
  "#{name} -> #{File.readlink(name)}"
end

def calculate_columns(max_filename_length)
  number_of_terminal_columns = `tput cols`.to_i
  return MAX_COLUMNS if number_of_terminal_columns > max_filename_length * MAX_COLUMNS

  1.upto(MAX_COLUMNS) do |column|
    break column if number_of_terminal_columns < max_filename_length * (column + 1)
  end
end

def calculate_rows(files, number_of_columns)
  (files.count.to_f / number_of_columns).ceil(0)
end

def display(files, number_of_rows, number_of_columns, max_filename_length)
  number_of_rows.times do |row|
    number_of_columns.times do |column|
      index = number_of_rows * column + row
      next unless files[index]

      print files[index].ljust(max_filename_length)
    end
    puts "\n"
  end
end

main
