require_relative './cell'
require_relative './grid'
module Sudoku
  # class generata sudoku game
  class Generate
    attr_reader :data, :grid
    def initialize(level)
      @level = level
      @max_delete = 45
      @max_delete = 60 if @level == 2
      @data = [
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
        [4, 5, 6, 7, 8, 9, 1, 2, 3],
        [7, 8, 9, 1, 2, 3, 4, 5, 6],
        [2, 3, 4, 5, 6, 7, 8, 9, 1],
        [5, 6, 7, 8, 9, 1, 2, 3, 4],
        [8, 9, 1, 2, 3, 4, 5, 6, 7],
        [3, 4, 5, 6, 7, 8, 9, 1, 2],
        [6, 7, 8, 9, 1, 2, 3, 4, 5],
        [9, 1, 2, 3, 4, 5, 6, 7, 8]
      ]
      a = %w(swapp_row swapp_col swapp_group_row swapp_group_col)
      @x = 0
      @y = 0
      @group = [0, 3, 6]
      10.times { send(a[Random.new.rand(0..3)]) }
      @grid = Grid.new(9, @data)
      @delete = 0
      erase
      @grid.each(&:set_org)
    end

    def erase
      a = []
      (0..80).each { |i| a.push(i) }
      while @delete < @max_delete
        i = Random.new.rand(0..a.length - 1)
        x = a[i] % 9
        y = a[i] / 9
        @grid[x, y].set(0)
        @grid.solve
        if @grid.valid? && @grid.missing == 0
          @delete += 1
          @grid[x, y].set(0)
          @grid[x, y].set_org
        end
        @grid.each(&:ret_org)
        a.delete(a[i])
        return if a.length == 0
      end
    end

    def solve
      t = 1
      while t > 0
        i = 0
        t = 0
        @grid.each do |x|
          row = (i / 9)
          col = i % 9
          if x.value != 0
            t += EXCLUDE.call(@grid.block_elems(row, col), x.value)
            t += EXCLUDE.call(@grid.row_elems(row), x.value)
            t += EXCLUDE.call(@grid.col_elems(col), x.value)
          end
          i += 1
        end
      end
    end

    def generatexy
      @x = @y
      while @x == @y
        @x = Random.new.rand(0..2)
        @y = Random.new.rand(0..2)
      end
    end

    def swapp_row
      generatexy
      g = Random.new.rand(0..2)
      @x = @group[g] + @x
      @y = @group[g] + @y
      pom = @data[@x]
      @data[@x] = @data[@y]
      @data[@y] = pom
    end

    def swapp_col
      generatexy
      g = Random.new.rand(0..2)
      @x = @group[g] + @x
      @y = @group[g] + @y
      (0..8).each do |n|
        pom = @data[n][@x]
        @data[n][@x] = @data[n][@y]
        @data[n][@y] = pom
      end
    end

    def swapp_group_row
      generatexy
      (0..2).each do |n|
        index_x = n + @group[@x]
        index_y = n + @group[@y]
        pom = @data[index_x]
        @data[index_x] = @data[index_y]
        @data[index_y] = pom
      end
    end

    def swapp_group_col
      generatexy
      (0..2).each do |n|
        index_x = n + @group[@x]
        index_y = n + @group[@y]
        (0..8).each do |m|
          pom = @data[m][index_x]
          @data[m][index_x] = @data[m][index_y]
          @data[m][index_y] = pom
        end
      end
    end
  end
end
