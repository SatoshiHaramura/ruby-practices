#!/usr/bin/env ruby
require 'optparse'
require 'date'

class Calendar
  def initialize(params)
    @year = params["y"]&.to_i
    @month = params["m"]&.to_i

    today = Date.today
    @year ||= today.year
    @month ||= today.month
  end

  def display
    first_date = Date.new(@year, @month, 1)
    dates = (first_date..Date.new(@year, @month, -1))
    puts "      #{@month}月 #{@year}"
    puts "日 月 火 水 木 金 土"
    print "   " * first_date.wday
    dates.each do |date|
      print date.day.to_s.rjust(2)
      date.saturday? ? (print "\n") : (print " ")
    end
    puts "\n\n"
  end
end

opt = OptionParser.new
params = ARGV.getopts("y:", "m:")

calendar = Calendar.new(params)
calendar.display
