#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_FRAME = 10
STRIKE = 10
SPARE = 10
STRIKE_MARK = -1

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << STRIKE
    shots << STRIKE_MARK
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  if frames.count < MAX_FRAME
    frames << s
  elsif s.count == 2
    frames[-1] << s.shift
    frames[-1] << s.pop
  else
    frames[-1] << s.shift
  end
end

frames.each do |frame|
  frame.delete(STRIKE_MARK)
end

strike_frames = []
spare_frames = []
frames.each_with_index do |frame, i|
  strike_frames << i if frame.count == 1
  spare_frames << i if (frame.count == 2) && (frame.sum == SPARE)
end

point = 0
frames.each_with_index do |frame, i|
  if strike_frames.include?(i)
    point += (STRIKE + frames[i + 1][0])
    point += if strike_frames.include?(i + 1)
               frames[i + 2][0]
             else
               frames[i + 1][1]
             end
  elsif spare_frames.include?(i)
    point += (SPARE + frames[i + 1][0])
  else
    point += frame.sum
  end
end
puts point
