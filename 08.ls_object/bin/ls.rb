#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/terminal'
require_relative '../lib/shell'
require_relative '../lib/kernel'
require_relative '../lib/ls'
require_relative '../lib/file'

def main
  terminal = Terminal.new
  terminal.accept_command(ARGV.getopts('arl'))
  print terminal.deliver
end

main
