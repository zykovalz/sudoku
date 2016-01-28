require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/sudoku/cell'

class TestCell < MiniTest::Unit::TestCase
  def setup
    @cell = Sudoku::Cell.new(1, 9)
  end

  def test_create
    assert_equal(1, @cell.value)
    assert_equal(-1, @cell.num_possible)
    @cell = Sudoku::Cell.new(0, 9)
    assert_equal(0, @cell.value)
    assert_equal(9, @cell.num_possible)
  end

  def test_set
    @cell.set(2)
    assert_equal(2, @cell.value)
    assert_equal(true, @cell.filled)
    @cell.set(0)
    assert_equal(0, @cell.value)
    assert_equal(false, @cell.filled)
  end

  def test_origin
    @cell.set_org
    assert_equal(1, @cell.origin)
    assert_equal(1, @cell.value)
    @cell.set(5)
    assert_equal(1, @cell.origin)
    assert_equal(5, @cell.value)
    @cell.ret_org
    assert_equal(1, @cell.value)
  end

  def test_exclude
    @cell.set(0)
    assert_equal(true, @cell.exclude(1))
    assert_equal(false, @cell.exclude(1))
    assert_equal(8, @cell.num_possible)
    (2..8).each do |i|
      @cell.exclude(i)
    end
    assert_equal(-1, @cell.num_possible)
    assert_equal(9, @cell.value)
  end
end
