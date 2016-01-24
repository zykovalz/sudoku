#!/bin/ruby
# Represent single number in sudoku grid which could
# have 9 possible values unless a values is already
# assigned
module Sudoku
  # class Cell
  class Cell
    def initialize(*args)
      if args.length == 2
        set(args[0])
        @possible = args[1] if args[0] == 0
      end
      @arr_possible = []
      (1..@possible).each { |i| @arr_possible.push(i) }
      set_org
    end

    def set_org
      @org = @num
    end

    def ret_org
      @num = @org
    end

    def origin
      @org
    end

    # true when value was already assigned
    def filled?
      @filled
    end

    def opts(num)
      @arr_possible.count(num) > 0
    end

    def set(num)
      if num == 0
        @possible = 9
        @filled = false
        @arr_possible = []
        (1..@possible).each { |i| @arr_possible.push(i) }
      else
        @possible = -1
        @filled = true
      end
      @num = num
    end

    # number of possible values at this position
    def num_possible
      @possible
    end

    # return true if number was deleted
    def exclude(num)
      @arr_possible.delete(num)
      if @arr_possible.length == 1
        set(@arr_possible[0])
        return true
      end
      return false if @possible == @arr_possible.length
      @possible = @arr_possible.length
      true
    end

    def to_i
      @num
    end

    def to_s
      @num
    end

    def value
      @num
    end
  end
end
