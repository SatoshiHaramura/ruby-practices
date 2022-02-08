#!/usr/bin/env ruby
# frozen_string_literal: true

class Game
  attr_reader :frames, :score
  private :frames, :score

  def initialize(frames)
    @frames = frames.map { |frame| Frame.new(frame) }
    @score = 0
  end

  def total_score
    frames.each_with_index do |frame, i|
      if frame.strike?
        @score += 10 + frames[i + 1].first_shot.score
        @score += if frames[i + 1].strike?
                    frames[i + 2].first_shot.score
                  else
                    frames[i + 1].second_shot.score
                  end
      elsif frame.spare?
        @score += 10 + frames[i + 1].first_shot.score
      else
        @score += frame.score
      end
    end
    score
  end
end
