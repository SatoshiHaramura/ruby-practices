#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/shot'

def main
  puts Game.new(ARGV[0]).total_score
end

main
