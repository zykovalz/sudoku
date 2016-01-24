#!/usr/bin/ruby
# encoding: utf-8
require_relative 'sudoku'
require_relative 'timegame'
require_relative 'result'
require_relative 'textfield'
require 'gosu'
include Gosu
module Sudoku
  # Gui for sudoku
  class SudokuGui < Window
    def initialize
      super(720, 540, false)
      self.caption = 'Sudoku'
      @level = 1
      spec = Gem::Specification.find_by_name('sudoku')
      gem_root = spec.gem_dir
      gem_lib = gem_root + '/lib/sudoku/img/'
      puts gem_root
      @sudoku = Sudoku.new(@level)
      @background = Image.new(self, gem_lib + 'grid.jpg', false)
      @new_game = Image.new(self, gem_lib + 'button.png', false)
      @control = Image.new(self, gem_lib + 'kontrol.png', false)
      @menu = Image.new(self, gem_lib + 'menu2.png', false)
      @menu2 = Image.new(self, gem_lib + 'menu.png', false)
      @save = Image.new(self,  'img/uloz.png', false)
      @sx = 74
      @sy = 129
      @fw = @fh	= 39
      @menu_y = height - 68
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
      @results = [Result.new('result.txt'), Result.new('result2.txt')]
      @solved = false
      @textfield = TextField.new(self, Font.new(self, 'Arial', 25), 500, 128)
    end

    def needs_cursor?
      true
    end

    def new_game
      @checked = false
      @sudoku = Sudoku.new(@level)
      @time.reset
      @stop = false
      @solved = false
    end

    def control
      @checked = true
      @color = 0xffff0000
      if @sudoku.correctly?
        @color = 0xff00ff00
        if @sudoku.solved?
          @stop = true
          @time.stop
          @results[@level - 1].save(@time.to_i)
        end
      end
    end

    def solve
      @sudoku.solve
      @color = 0xff00ff00 if @sudoku.correctly?
      @solved = true
    end

    def save
      @results[@level - 1].write(@textfield.text) if @stop
      new_game
    end

    def button_down(id)
      x = mouse_x
      y = mouse_y
      if id == MsLeft
        if (@sx..@sx + 9 * @fw).cover?(x) && (@sy..@sy + 9 * @fw).cover?(y)
          @active = [(x.to_i - @sx) / @fw, (y.to_i - @sy) / @fh]
        else
          @active = [nil, nil]
        end
        if save_result?
          save if (500..600).cover?(x) && (170..208).cover?(y)
          self.text_input = @textfield if @textfield.under_point?(x, y)
          self.text_input.move_caret(mouse_x) unless self.text_input.nil?
        else
          new_game if (500..635).cover?(x) && (128..167).cover?(y)
          control if (500..677).cover?(x) && (283..321).cover?(y)
          solve if (505..621).cover?(x) && (335..374).cover?(y)
          @level = 1 if (500..618).cover?(x) && (181..220).cover?(y)
          @level = 2 if (500..618).cover?(x) && (230..270).cover?(y)
        end
      elsif @active != [nil, nil] && !@stop && @sudoku.grid[@active[1], @active[0]].origin == 0
        case id
        when Kb1, KbNumpad1 then @sudoku.grid[@active[1], @active[0]].set(1)
        when Kb2, KbNumpad2 then @sudoku.grid[@active[1], @active[0]].set(2)
        when Kb3, KbNumpad3 then @sudoku.grid[@active[1], @active[0]].set(3)
        when Kb4, KbNumpad4 then @sudoku.grid[@active[1], @active[0]].set(4)
        when Kb5, KbNumpad5 then @sudoku.grid[@active[1], @active[0]].set(5)
        when Kb6, KbNumpad6 then @sudoku.grid[@active[1], @active[0]].set(6)
        when Kb7, KbNumpad7 then @sudoku.grid[@active[1], @active[0]].set(7)
        when Kb8, KbNumpad8 then @sudoku.grid[@active[1], @active[0]].set(8)
        when Kb9, KbNumpad9 then @sudoku.grid[@active[1], @active[0]].set(9)
        when KbDelete, KbBackspace then @sudoku.grid[@active[1], @active[0],].set(0)
        end
      end
      if @active != [nil, nil]
        case id
        when KbUp then @active[1] = (@active[1] - 1) % 9
        when KbLeft then @active[0] = (@active[0] - 1) % 9
        when KbRight then @active[0] = (@active[0] + 1) % 9
        when KbDown then @active[1] = (@active[1] + 1) % 9
        end
      end
    end

    def save_result?
      !@solved && @stop
    end

    def draw
      @background.draw(0, 0, 0)
      @menu.draw(500, 128, 0) if @level == 1 && !save_result?
      @menu2.draw(500, 128, 0) if @level == 2 && !save_result?
      if save_result?
        @save.draw(500, 170, 0)
        @textfield.draw
        @results[@level - 1].data.each_with_index do |x, i|
          t = Time.at(x[1]).utc.strftime '%H:%M:%S'
          c = Color.new(136, 0, 0)
          c = Color.new(0, 0, 0) if @results[@level - 1].index == i
          @font20.draw("#{i + 1}. #{x[0]} #{t}", 500, (i + 1) * 25 + 200, 2, 1.0, 1.0, c)
        end
      end
      @sudoku.to_a.each_with_index do |e, i|
        c = Color.new(136, 0, 0)
        c = 0xff000000 unless e.origin == 0
        @font.draw(e.to_i, @sx + 12 + i % 9 * @fw, @sy + 2 + i / 9 * @fw, 2, 1.0, 1.0, c) unless e.to_i == 0
      end
      @now = @time.to_s unless @stop
      @font35.draw("Čas: #{@now}", 500, 50, 2, 1.0, 1.0, Color.new(136, 0, 0))
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
      if @checked
        c = @color
        draw_quad(68, 127, c, 68, 486, c, 72, 486, c, 72, 127, c, 3)
        draw_quad(69, 126, c, 430, 126, c, 430, 130, c, 69, 130, c, 3)
        draw_quad(426, 130, c, 426, 486, c, 430, 486, c, 430, 130, c, 3)
        draw_quad(72, 482, c, 430, 482, c, 430, 486, c, 72, 486, c, 3)
      end
    end
  end
end
Sudoku::SudokuGui.new.show
