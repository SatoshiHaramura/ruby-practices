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
    files_info = retrieve_files_info(files_name)
    display_files_info(files_info)
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
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  files_name = Dir.glob('*', flags)
  files_name = files_name.reverse if options['r']
  files_name
end

def check_filename_length(files_name)
  files_name.map(&:length).max
end

def calculate_max_filename_length(filename_length)
  FILENAME_LENGTH_UNIT * ((filename_length / FILENAME_LENGTH_UNIT) + 1)
end

def retrieve_files_info(files_name)
  files_name.map do |name|
    file = {}
    file_stat = File.lstat(name)
    file[:name] = name
    file[:type] = check_type(name)
    file[:permission] = check_permission(file_stat)
    file[:link] = file_stat.nlink.to_s
    file[:owner] = Etc.getpwuid(file_stat.uid).name
    file[:group] = Etc.getgrgid(file_stat.gid).name
    file[:size] = file_stat.size.to_s
    file[:month] = file_stat.mtime.month.to_s
    file[:day] = file_stat.mtime.day.to_s
    file[:time] = file_stat.mtime.strftime('%H:%M').to_s
    file[:blocks] = file_stat.blocks
    file
  end
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

def display_files_info(files)
  max_link_length = files.map { |f| f[:link].length }.max
  max_owner_length = files.map { |f| f[:owner].length }.max
  max_group_length = files.map { |f| f[:group].length }.max
  max_size_length = files.map { |f| f[:size].length }.max
  block_size = files.map { |f| f[:blocks] }.sum

  puts "total #{block_size}"
  files.each do |file|
    print file[:type]
    print "#{file[:permission]} "
    print "#{file[:link].rjust(max_link_length + 1)} "
    print "#{file[:owner].ljust(max_owner_length)}  "
    print "#{file[:group].ljust(max_group_length)} "
    print "#{file[:size].rjust(max_size_length + 1)} "
    print "#{file[:month].rjust(2)} "
    print "#{file[:day].rjust(2)} "
    print "#{file[:time]} "
    print file[:type] == 'l' ? export_symlink_name(file[:name]) : file[:name]
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
