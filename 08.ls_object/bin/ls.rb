#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'io/console'
require_relative '../lib/ls'
require_relative '../lib/file'

def main
  ls = Command::Ls.new(ARGV.getopts('arl'), IO.console.winsize[1])
  ls.execute.inject { |res, str| res + str }
end

main
