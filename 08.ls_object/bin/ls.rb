#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'io/console'
require_relative '../lib/ls'
require_relative '../lib/short_format'
require_relative '../lib/long_format'
require_relative '../lib/file'

def main
  ls = Command::Ls.new(ARGV.getopts('arl'), IO.console.winsize[1])
  print(ls.execute.inject { |res, str| res + str })
end

main
