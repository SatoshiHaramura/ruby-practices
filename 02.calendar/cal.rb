#!/usr/bin/env ruby
require 'optparse'
require 'date'

class Calendar
  FIRST_DAY = 1

  def initialize(params)
    @year = params["y"]
    @month = params["m"]
    today = Date.today

    @year ||= today.year
    @month ||= today.month

    @year = @year.to_i if @year.class != "Integer"
    @month = @month.to_i if @month.class != "Integer"
  end

  def display
    first_day = Date.new(@year, @month, FIRST_DAY)
    last_day = Date.new(@year, @month, -1).day
    days = []
    days = (FIRST_DAY..last_day).to_a
    puts "      #{@month}月 #{@year}"
    puts "日 月 火 水 木 金 土"
    printf "   " * first_day.wday
    days.each do |day|
      if (first_day + day - FIRST_DAY).saturday?
        print day.to_s.rjust(2) + "\n"
      else
        print day.to_s.rjust(2) + " "
      end
    end
    puts "\n\n"
  end
end

opt = OptionParser.new
params = ARGV.getopts("y:", "m:")

calendar = Calendar.new(params)
calendar.display
