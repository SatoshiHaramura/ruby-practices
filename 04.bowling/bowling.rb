#!/usr/bin/env ruby
# frozen_string_literal: true

STRIKE = 10
SPARE = 10

score = ARGV[0]
scores = score.split(',')

frame = []
frames = []
scores.each do |s|
  frame << (s == 'X' ? STRIKE : s.to_i)
  # (9フレーム目まで) && (frameが既に2投分の情報を持つ || ストライクのとき)
  if (frames.count < 9) && ((frame.count == 2) || (frame[0] == STRIKE))
    frames << frame
    frame = []
  end
end
# 10フレーム目としてスコアを格納
frames << frame

point = 0
frames.each_with_index do |f, i|
  if f.count == 1
    point += (STRIKE + frames[i + 1][0])
    point += if frames[i + 1].count == 1
               frames[i + 2][0]
             else
               frames[i + 1][1]
             end
  elsif (f.count == 2) && (f.sum == SPARE)
    point += (SPARE + frames[i + 1][0])
  else
    point += f.sum
  end
end
puts point
