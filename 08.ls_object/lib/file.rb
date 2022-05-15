# frozen_string_literal: true

require 'etc'
require 'pathname'

TYPE_TABLE = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSION_TABLE = {
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

module Storage
  class File
    attr_reader :name, :detail_info

    def initialize(name)
      @name = name
    end

    def build_detail_info
      stat = ::File.lstat(name)

      @detail_info = {
        type: TYPE_TABLE[::File.ftype(name)],
        permission: format_permission(stat),
        link: stat.nlink.to_s,
        owner: Etc.getpwuid(stat.uid).name,
        group: Etc.getgrgid(stat.gid).name,
        size: stat.size.to_s,
        month: stat.mtime.month.to_s,
        day: stat.mtime.day.to_s,
        time: stat.mtime.strftime('%H:%M').to_s,
        blocks: stat.blocks
      }

      check_excute_permission(stat)
    end

    private

    def format_permission(stat)
      digits = stat.mode.to_s(8)[-3..]
      digits.gsub(/./, PERMISSION_TABLE)
    end

    def check_excute_permission(stat)
      set_owner_excute_permission if stat.setuid?
      set_group_excute_permission if stat.setgid?
      set_other_excute_permission if stat.sticky?
    end

    def set_owner_excute_permission
      detail_info[:permission][2] = detail_info[:permission][2] == 'x' ? 's' : 'S'
    end

    def set_group_excute_permission
      detail_info[:permission][5] = detail_info[:permission][5] == 'x' ? 's' : 'S'
    end

    def set_other_excute_permission
      detail_info[:permission][8] = detail_info[:permission][8] == 'x' ? 't' : 'T'
    end
  end
end
