#!/usr/bin/ruby
# encoding: utf-8
require_relative 'sudoku'
require_relative 'timegame'
require_relative 'result'
require_relative 'textfield'
require_relative 'menu'
require 'gosu'
include Gosu
module Sudoku
  # Gui for sudoku
  class SudokuGui < Window
    def initialize
      super(720, 540, false)
      self.caption = 'Sudoku'
      spec = Gem::Specification.find_by_name('sudoku')
      gem_lib = spec.gem_dir + '/lib/sudoku/img/'
      @sudoku = Sudoku.new(1)
      @background = Image.new(self, gem_lib + 'grid.jpg', false)
      @menu = Menu.new(gem_lib, self)
      @save = Image.new(self, gem_lib + 'uloz.png', false)
      @sx = 74
      @sy = 129
      @fw = @fh	= 39
      @font = Font.new(self, 'Arial', 50)
      @font20 = Font.new(self, 'Arial', 20)
      @font35 = Font.new(self, 'Arial', 35)
      @active = [nil, nil]
      @ns = 0
      @checked = false
      @color = 0xffff0000
      @time = TimeGame.new
      @now = @time.to_s
      @stop = false
      @results = [Result.new(ENV['HOME'] + '/' + 'result.txt', @font20),
                  Result.new(ENV['HOME'] + '/' + 'result2.txt', @font20)]
      @solved = false
      @textfield = TextField.new(self, Font.new(self, 'Arial', 25), 500, 128)
    end

    def needs_cursor?
      true
    end

    def new_game(level)
      @checked = false
      @sudoku = Sudoku.new(level)
      @time.reset
      @stop = false
      @solved = false
    end

    def control
      @checked = true
      @color = 0xffff0000
      return unless @sudoku.correctly?
      @color = 0xff00ff00
      return unless @sudoku.solved?
      @stop = true
      @time.stop
      @results[@menu.level - 1].save(@time.to_i)
    end

    def solve
      @sudoku.solve
      @solved = true
      control
    end

    def save
      @results[@menu.level - 1].write(@textfield.text) if @stop
      new_game(@menu.level)
    end

    def write(id)
      @checked = false
      if id >= Kb1 && id <= Kb9
        @sudoku.grid[@active[1], @active[0]].set(id - Kb1 + 1)
      elsif id >= KbNumpad1 && id <= KbNumpad9
        @sudoku.grid[@active[1], @active[0]].set(id - KbNumpad1 + 1)
      elsif [98, 39, KbBackspace, KbDelete].include? id
        @sudoku.grid[@active[1], @active[0]].set(0)
      end
    end

    def move(id)
      case id
      when KbUp then @active[1] = (@active[1] - 1) % 9
      when KbLeft then @active[0] = (@active[0] - 1) % 9
      when KbRight then @active[0] = (@active[0] + 1) % 9
      when KbDown then @active[1] = (@active[1] + 1) % 9
      end
    end

    def set_save(x, y)
      save if (500..600).cover?(x) && (170..208).cover?(y)
      self.text_input = @textfield if @textfield.under_point?(x, y)
      self.text_input.move_caret(mouse_x) unless self.text_input.nil?
    end

    def click
      x = mouse_x
      y = mouse_y
      self.text_input = nil
      if (@sx..@sx + 9 * @fw).cover?(x) && (@sy..@sy + 9 * @fw).cover?(y)
        @active = [(x.to_i - @sx) / @fw, (y.to_i - @sy) / @fh]
      else
        @active = [nil, nil]
      end
      if save_result?
        set_save(x, y)
      else
        @menu.action(x, y)
      end
    end

    def button_down(id)
      if id == MsLeft
        click
      elsif @active != [nil, nil]
        write(id) if !@stop && @sudoku.grid[@active[1], @active[0]].origin == 0
        move(id)
      end
    end

    def save_result?
      !@solved && @stop && @results[@menu.level - 1].index < 10
    end

    def draw_grid
      x = @sx + 12
      y = @sy + 2
      @sudoku.to_a.each_with_index do |e, i|
        next if e.to_i == 0
        c = Color.new(136, 0, 0)
        c = 0xff000000 unless e.origin == 0
        @font.draw(e.to_i, x + i % 9 * @fw, y + i / 9 * @fw, 2, 1, 1, c)
      end
    end

    def draw
      @background.draw(0, 0, 0)
      @menu.draw
      draw_grid
      if save_result?
        @save.draw(500, 170, 0) if @results[@menu.level - 1].index < 10
        @textfield.draw if @results[@menu.level - 1].index < 10
        @results[@menu.level - 1].draw
      end
      @time.draw(@font35, Color.new(136, 0, 0))
      if @active != [nil, nil]
        x1 = @active[0] * @fw + @sx + @active[0] / 3 + 2
        x2 = x1 + @fw
        y1 = @active[1] * @fh + @sy + @active[1] / 3 + 2
        y2 = y1 + @fh
        c = Color.new(136, 0, 0)
        draw_quad(x1 - 4, y1 - 3, c, x1 - 4, y2, c, x1, y2, c, x1, y1 - 3, c, 3)
        draw_quad(x1 - 3, y1 - 4, c, x2, y1 - 4, c, x2, y1, c, x1 - 3, y1, c, 3)
        draw_quad(x2 - 4, y1, c, x2 - 4, y2, c, x2, y2, c, x2, y1, c, 3)
        draw_quad(x1, y2 - 4, c, x2, y2 - 4, c, x2, y2, c, x1, y2, c, 3)
      end
      return unless @checked
      c = @color
      draw_quad(68, 127, c, 68, 486, c, 72, 486, c, 72, 127, c, 3)
      draw_quad(69, 126, c, 430, 126, c, 430, 130, c, 69, 130, c, 3)
      draw_quad(426, 130, c, 426, 486, c, 430, 486, c, 430, 130, c, 3)
      draw_quad(72, 482, c, 430, 482, c, 430, 486, c, 72, 486, c, 3)
    end
  end
end
