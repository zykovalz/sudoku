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
  class Menu
    attr_reader :level
    def initialize(path, window)
      @window = window
      @level = 1
      @menu = Image.new(path + 'menu2.png')
      @menu2 = Image.new(path + 'menu.png')
    end

    def action(x, y)
      @window.new_game(@level) if (500..635).cover?(x) && (128..167).cover?(y)
      @window.control if (500..677).cover?(x) && (283..321).cover?(y)
      @window.solve if (505..621).cover?(x) && (335..374).cover?(y)
      if (500..618).cover?(x) && (181..220).cover?(y)
        @level = 1
      elsif (500..618).cover?(x) && (230..270).cover?(y)
        @level = 2
      end
    end

    def draw
      @menu.draw(500, 128, 0) if @level == 1 && !@window.save_result?
      @menu2.draw(500, 128, 0) if @level == 2 && !@window.save_result?
    end
  end
end
