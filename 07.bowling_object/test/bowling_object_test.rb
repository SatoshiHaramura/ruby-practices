#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/shot'

class BowlingObjectTest < Minitest::Test
  def test_bowling_object_score_a
    argv = 'X,X,X,X,X,X,X,X,X,X,X,X'

    assert_equal 300, Game.new(argv).total_score
  end

  def test_bowling_object_score_b
    argv = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'

    assert_equal 139, Game.new(argv).total_score
  end

  def test_bowling_object_score_c
    argv = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'

    assert_equal 164, Game.new(argv).total_score
  end

  def test_bowling_object_score_d
    argv = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'

    assert_equal 107, Game.new(argv).total_score
  end

  def test_bowling_object_score_e
    argv = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'

    assert_equal 134, Game.new(argv).total_score
  end

  def test_bowling_object_score_f
    argv = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,2,1,4'

    assert_equal 110, Game.new(argv).total_score
  end
end
