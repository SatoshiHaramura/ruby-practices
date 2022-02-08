#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

def main
  marks = ARGV[0].split(',')
  frames = separate(marks)

  puts Game.new(frames).total_score
end

def separate(marks)
  frame = []
  frames = []
  marks.each do |mark|
    frame << mark
    if (frames.count < 9) && ((frame.count == 2) || (frame[0] == 'X'))
      frames << frame
      frame = []
    end
  end
  frames << frame
end

main
