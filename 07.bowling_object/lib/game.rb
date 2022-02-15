#!/usr/bin/env ruby
# frozen_string_literal: true

class Game
  attr_reader :frames, :score
  private :frames, :score

  def initialize(marks)
    separated_marks = Game.separate(marks)
    @frames = separated_marks.map { |mark| Frame.new(mark) }
    @score = 0
  end

  def self.separate(args)
    marks = args.split(',')
    marks_array = []
    marks_arrays = []

    marks.each do |mark|
      marks_array << mark
      if (marks_arrays.count < 9) && ((marks_array.count == 2) || (marks_array[0] == 'X'))
        marks_arrays << marks_array
        marks_array = []
      end
    end
    marks_arrays << marks_array
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
