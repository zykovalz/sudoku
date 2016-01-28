require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/sudoku/grid'

class TestGrid < MiniTest::Unit::TestCase
  def setup
    @data = [
      [1, 2, 3, 4, 5, 6, 7, 8, 9], [4, 5, 6, 7, 8, 9, 1, 2, 3],
      [7, 8, 9, 1, 2, 3, 4, 5, 6],
      [2, 3, 4, 5, 6, 7, 8, 9, 1],
      [5, 6, 7, 8, 9, 1, 2, 3, 4],
      [8, 9, 1, 2, 3, 4, 5, 6, 7],
      [3, 4, 5, 6, 7, 8, 9, 1, 2],
      [6, 7, 8, 9, 1, 2, 3, 4, 5],
      [9, 1, 2, 3, 4, 5, 6, 7, 8]]
  end

  def test_valid
    assert_equal(true, Sudoku::Grid.new(9, @data).valid?)
    @data[0][8] = 1
    assert_equal(false, Sudoku::Grid.new(9, @data).valid?)
    @data[0][8] = 0
    @data[0][0] = 0
    @data[2][2] = 0
    assert_equal(true, Sudoku::Grid.new(9, @data).valid?)
  end

  def test_solve
    @data[0][0] = 0
    @data[1][1] = 0
    @data[7][2] = 0
    @data[4][4] = 0
    @data[8][7] = 0
    s = Sudoku::Grid.new(9, @data)
    assert_equal(5, s.missing)
    s.solve
    assert_equal(0, s.missing)
    assert_equal(true, s.valid?)
  end
end
