require 'minitest/unit'
require 'minitest/autorun'
require 'timecop'
require_relative '../lib/sudoku/timegame'

class TestTimeGame < MiniTest::Unit::TestCase
  def setup
    @time = Sudoku::TimeGame.new
  end

  def test_time
    assert_equal('00:00:00', @time.to_s)
    Timecop.travel(10)
    assert_equal('00:00:10', @time.to_s)
    @time.stop
    assert_equal('00:00:10', @time.to_s)
    Timecop.travel(10)
    assert_equal('00:00:10', @time.to_s)
  end

  def test_stop
    Timecop.travel(15)
    @time.stop
    assert_equal('00:00:15', @time.to_s)
    Timecop.travel(10)
    assert_equal('00:00:15', @time.to_s)
  end

  def test_reset
    Timecop.travel(25)
    @time.reset
    assert_equal('00:00:00', @time.to_s)
  end

  def test_string
    Timecop.travel(60)
    assert_equal('00:01:00', @time.to_s)
    Timecop.travel(5)
    assert_equal('00:01:05', @time.to_s)
    Timecop.travel(3600)
    assert_equal('01:01:05', @time.to_s)
  end
end
