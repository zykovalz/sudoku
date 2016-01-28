require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/sudoku/result'

class TestResult < MiniTest::Unit::TestCase
  def setup
    File.delete('pokus.txt') if File.exist?('pokus.txt')
    @result = Sudoku::Result.new('pokus.txt', nil)
  end

  def teardown
    File.delete('pokus.txt') if File.exist?('pokus.txt')
  end

  def test_save
    @result.save(10)
    assert_equal(1, @result.data.length)
    assert_equal('Novy', @result.data[0][0])
    assert_equal(10, @result.data[0][1])
    @result.write('name')
    assert_equal('name', @result.data[0][0])
    assert_equal(10, @result.data[0][1])
  end

  def test_sort
    (9).downto(1) do |i|
      @result.save(i)
      @result.write("name#{i}")
      assert_equal(0, @result.index)
    end
    assert_equal(9, @result.data.length)
    (0..8).each do |i|
      assert_equal("name#{i + 1}", @result.data[i][0])
      assert_equal(i + 1, @result.data[i][1])
    end
  end

  def test_loading
    (3).downto(1) do |i|
      @result.save(i)
      @result.write("n#{i}")
      assert_equal(0, @result.index)
    end
    @result = Sudoku::Result.new('pokus.txt', nil)
    assert_equal("n1 00:00:01\nn2 00:00:02\nn3 00:00:03\n", @result.to_s)
    assert_equal(3, @result.data.length)
    assert_equal('n3', @result.data[2][0])
    assert_equal(3, @result.data[2][1])
  end
end
