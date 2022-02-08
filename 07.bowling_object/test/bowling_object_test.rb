#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/shot'

class BowlingObjectTest < Minitest::Test
  def test_bowling_object_score_a
    frames = [['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], %w[X X X]]

    assert_equal 300, Game.new(frames).total_score
  end

  def test_bowling_object_score_b
    frames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], [6, 4, 5]]

    assert_equal 139, Game.new(frames).total_score
  end

  def test_bowling_object_score_c
    frames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], %w[X X X]]

    assert_equal 164, Game.new(frames).total_score
  end

  def test_bowling_object_score_d
    frames = [[0, 10], [1, 5], [0, 0], [0, 0], ['X'], ['X'], ['X'], [5, 1], [8, 1], [0, 4]]

    assert_equal 107, Game.new(frames).total_score
  end

  def test_bowling_object_score_e
    frames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], ['X', 0, 0]]

    assert_equal 134, Game.new(frames).total_score
  end

  def test_bowling_object_score_f
    frames = [[0, 10], [1, 5], [0, 0], [0, 0], ['X'], ['X'], ['X'], [5, 1], [8, 2], [1, 4]]

    assert_equal 110, Game.new(frames).total_score
  end
end
