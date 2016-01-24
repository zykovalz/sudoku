#!/bin/ruby
require_relative './grid'

# Parse string for 9x9 sudoku game
#
class StringParser
  # Static methods will follow
  class << self
    # Return true if passed object
    # is supported by this loader
    def supports?(arg)
      return true if arg.is_a?(String) && /^[0-9.]{81}/.match(arg)
      false
    end

    # Return Grid object when finished
    # parsing
    def load(arg)
      return nil unless supports? arg
      grid = Grid.new(9)
      i = 0
      arg.each_char do |char|
        row = (i / 9)
        column = i % 9
        i += 1
        grid[row, column] = char.to_i
      end
      grid
    end
  end
end
