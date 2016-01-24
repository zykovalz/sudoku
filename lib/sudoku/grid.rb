#!/usr/bin/env ruby

require_relative './cell'

module Sudoku
  EXCLUDE = lambda do |enum, val|
    t = 0
    enum.each do |e|
      t += 1 if e.value == 0 && e.exclude(val)
    end
    t
  end
  # Contains sudoku game board
  class Grid
    include Enumerable
    # Create Sudoku game grid of given dimension
    def initialize(dimension, data)
      @dimension = dimension
      @grid = Array.new(dimension) do
        Array.new(dimension)
      end
      data.each_with_index do |e, i|
        e.each_with_index do |y, x|
          @grid[i][x] = Cell.new(y, @dimension)
        end
      end
      @grid
    end

    # Return value at given position
    def value(x, y)
      @grid[x][y].value
    end

    def find_prev(zero, pos)
      pos = zero.index(pos) - 1
      return -1 if pos < 0
      zero[pos]
    end

    def try_value(row, col, zero, pos)
      h = value(row, col) + 1
      if h > 9
        self[row, col].set(0)
        pos = find_prev(zero, pos)
      else
        self[row, col].set(h)
        pos += 1 if valid?
      end
      pos
    end

    def fill(z)
      pos = 0
      while pos >= 0
        r = pos / 9
        c = pos % 9
        return true if pos == 81
        self[r, c].origin == 0 ? pos = try_value(r, c, z, pos) : pos += 1
      end
    end

    def numeric
      zero = []
      i = 0
      each do |x|
        zero.push(i) unless x.filled?
        x.set_org
        i += 1
      end
      fill(zero)
    end

    def exclude_call(x, row, col)
      t = 0
      t += EXCLUDE.call(block_elems(row, col), x.value)
      t += EXCLUDE.call(row_elems(row), x.value)
      t += EXCLUDE.call(col_elems(col), x.value)
      t
    end

    def solve
      t = 1
      while t > 0
        t = 0
        each_with_index do |x, i|
          row = (i / 9)
          col = i % 9
          t += exclude_call(x, row, col) if x.value != 0
        end
      end
    end

    # Marks number +z+ which shouldn't be at position [x, y]
    def exclude(x, y, z)
      @grid[x][y].exclude(z)
    end

    # True when there is already a number
    def filled?(x, y)
      @grid[x][y].value != 0
    end

    # True when no game was loaded
    def empty?
      each do |cell|
        return false if cell.value.to_i != 0
      end
      true
    end

    # Yields elements in given row
    def row_elems(x)
      return @grid[x] unless block_given?
      @grid[x].each do |g|
        yield g
      end
    end

    def typ_arg(arg)
      return 0 if arg < 3
      return 1 if arg < 6
      2
    end

    def block_row?(arg, i)
      typ_arg(arg) == typ_arg(i)
    end

    def block_col?(arg, col)
      arg % 3 == typ_arg(col)
    end

    def block(arg)
      res = []
      i = 0
      each do |x|
        row = (i / 9)
        col = (i % 9)
        res.push(x) if block_row?(arg, row) && block_col?(arg, col)
        i += 1
      end
      return res unless block_given?
      res.each { |g| yield g }
    end

    # Yields elements in given column
    def col_elems(y)
      col = []
      @grid.each do |sub|
        yield sub[y] if block_given?
        col.push(sub[y]) unless block_given?
      end
      col unless block_given?
    end

    def number_block(x, y)
      (3 * (x / 3)) + y / 3
    end

    # Yields elements from block which is
    # containing element at given position
    def block_elems(x, y)
      return block(number_block(x, y)) unless block_given?
      block(number_block(x, y)).each { |v| yield v }
    end

    # With one argument return row, with 2, element
    # at given position
    def [](*args)
      if args.length == 1
        @grid[args[0]]
      else
        @grid[args[0]][args[1]]
      end
    end

    # With one argument sets row, with 2 element
    def []=(*args)
      if args.length == 2
        @grid[args[0]] = args[1]
      else
        @grid[args[0]][args[1]] = Cell.new(args[2], @dimension)
      end
    end

    # Return number of missing numbers in grid
    def missing
      num = 0
      each do |cell|
        num += 1 if cell.value.to_i == 0
      end
      num
    end

    # Number of filled cells
    def filled
      num = 0
      each do |cell|
        num += 1 if cell.value.to_i != 0
      end
      num
    end

    # Number of rows in this sudoku
    def rows
      @dimension
    end

    # Number of columns in this sudoku
    def cols
      @dimension
    end

    # Iterates over all elements, left to right, top to bottom
    def each
      return to_enum(:each) unless block_given?
      @grid.each do |sub|
        sub.each do |cell|
          yield cell
        end
      end
    end

    def valid_enum(enum)
      pom = []
      enum.each do |e|
        return false if pom.count(e.to_i) > 0 && e.to_i != 0
        pom << e.to_i
      end
      true
    end

    # Return true if no filled number break sudoku rules
    def valid?
      (0..@dimension - 1).each do |i|
        return false unless valid_enum(row_elems(i))
        return false unless valid_enum(col_elems(i))
        return false unless valid_enum(block(i))
      end
      true
    end

    # Serialize grid values to a one line string
    def solution
      solution = ''
      each do |cell|
        solution += cell.value.to_s
      end
      solution
    end
  end
end
