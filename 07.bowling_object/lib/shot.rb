#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  attr_reader :mark
  private :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    mark == 'X' ? 10 : mark.to_i
  end
end
