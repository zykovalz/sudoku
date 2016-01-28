require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/sudoku/gui'

class TestGui < MiniTest::Unit::TestCase
  def setup
    @gui = Sudoku::SudokuGui.new
  end

  def test_window
    assert_equal(720, @gui.width)
    assert_equal(540, @gui.height)
  end
end
