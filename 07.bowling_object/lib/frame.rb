#!/usr/bin/env ruby
# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :shot_count
  private :shot_count

  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1] || 0)
    @third_shot = Shot.new(shots[2] || 0)
    @shot_count = shots.count
  end

  def score
    [first_shot.score, second_shot.score, third_shot.score].sum
  end

  def strike?
    (shot_count == 1) && (first_shot.score == 10)
  end

  def spare?
    (shot_count == 2) && ([first_shot.score, second_shot.score].sum == 10)
  end
end
