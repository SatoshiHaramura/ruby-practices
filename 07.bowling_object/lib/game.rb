#!/usr/bin/env ruby
# frozen_string_literal: true

class Game
  private attr_reader :frames, :score

  def initialize(args)
    @frames = create_frames(args)
    @score = 0
  end

  def create_frames(args)
    marks = args.split(',')
    marks_tmp = []
    frames = []

    marks.each do |mark|
      marks_tmp << mark
      if (frames.count < 9) && ((marks_tmp.count == 2) || (marks_tmp[0] == 'X'))
        frames << Frame.new(marks_tmp)
        marks_tmp = []
      end
    end
    frames << Frame.new(marks_tmp)
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
