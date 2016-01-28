require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/sudoku/generate'

class TestGenerate < MiniTest::Unit::TestCase
  def test_level
    assert_equal(45, Sudoku::Generate.new(1).grid.missing)
    assert_equal(55, Sudoku::Generate.new(2).grid.missing)
  end

  def test_valid
    3.times do
      assert_equal(true, Sudoku::Generate.new(1).grid.valid?)
      assert_equal(true, Sudoku::Generate.new(2).grid.valid?)
    end
  end

  def test_is_solvable
    3.times do
      generate = Sudoku::Generate.new(1)
      generate.solve
      assert_equal(0, generate.grid.missing)
      generate = Sudoku::Generate.new(2)
      generate.solve
      assert_equal(0, generate.grid.missing)
    end
  end
end
