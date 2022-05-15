# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'
require_relative '../lib/short_format'
require_relative '../lib/long_format'
require_relative '../lib/file'

class LSCommandTest < Minitest::Test
  def test_exec_ls_with_forty_eight
    expected = <<~TEXT
      aaaaaaaaaaaaaaa sample          sample5
      link            sample1         sample6
      link2           sample2         test
      link3           sample3
      ls.rb           sample4
    TEXT

    ls = Command::Ls.new({ 'a' => false, 'r' => false, 'l' => false }, 48)

    assert_equal expected, (ls.execute.inject { |res, str| res + str })
  end

  def test_exec_ls_with_forty_seven
    expected = <<~TEXT
      aaaaaaaaaaaaaaa sample2
      link            sample3
      link2           sample4
      link3           sample5
      ls.rb           sample6
      sample          test
      sample1
    TEXT

    ls = Command::Ls.new({ 'a' => false, 'r' => false, 'l' => false }, 47)

    assert_equal expected, (ls.execute.inject { |res, str| res + str })
  end

  def test_exec_ls_with_a_option
    expected = <<~TEXT
      .               link3           sample3
      .gitkeep        ls.rb           sample4
      aaaaaaaaaaaaaaa sample          sample5
      link            sample1         sample6
      link2           sample2         test
    TEXT

    ls = Command::Ls.new({ 'a' => true, 'r' => false, 'l' => false }, 48)

    assert_equal expected, (ls.execute.inject { |res, str| res + str })
  end

  def test_exec_ls_with_r_option
    expected = <<~TEXT
      test            sample2         link2
      sample6         sample1         link
      sample5         sample          aaaaaaaaaaaaaaa
      sample4         ls.rb
      sample3         link3
    TEXT

    ls = Command::Ls.new({ 'a' => false, 'r' => true, 'l' => false }, 48)

    assert_equal expected, (ls.execute.inject { |res, str| res + str })
  end

  def test_exec_ls_with_l_option
    expected = <<~TEXT
      total 8
      -rw-r--r--  1 haramura  staff     0 11 21 15:22 aaaaaaaaaaaaaaa
      drwxr-xr-T  3 haramura  staff    96 11 15 18:58 link
      -rw-r--r--  1 haramura  staff     0 11 16 22:46 link2
      lrwxr-xr-x  1 haramura  staff     6  3  4 15:12 link3 -> sample
      -rwxrwxrwx  1 haramura  staff  1006 11 27 07:40 ls.rb
      -rw-r--r--  1 haramura  staff     0 11 16 22:46 sample
      -rwsr--r--  1 haramura  staff     0 11 16 22:47 sample1
      -rwSr--r--  1 haramura  staff     0 11 16 22:46 sample2
      -rw-r-sr--  1 haramura  staff     0 11 16 22:46 sample3
      -rw-r-Sr--  1 haramura  staff     0 11 16 22:47 sample4
      -rw-r--r-t  1 haramura  staff     0 11 16 22:47 sample5
      -rw-r--r-T  1 haramura  staff     0 11 16 22:47 sample6
      drwxr-xr-T  3 haramura  staff    96 11 15 18:58 test
    TEXT

    ls = Command::Ls.new({ 'a' => false, 'r' => false, 'l' => true }, 48)

    assert_equal expected, (ls.execute.inject { |res, str| res + str })
  end
end
