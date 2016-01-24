#!/bin/ruby
require_relative './grid'
require_relative './generate'
require 'sudoku/version'
# module Sudoku
module Sudoku
  EXCLUDE = lambda do |enum, val|
    t = 0
    enum.each do |e|
      t += 1 if e.value == 0 && e.exclude(val)
    end
    t
  end
  # Basic sudoku solver
  class Sudoku
    attr_reader :grid
    def initialize(level)
      generate(level)
      clean
    end

    def generate(level)
      @grid = Generate.new(level).grid
    end
    # Return true when there is no missing number
    def solved?
      !@grid.nil? && @grid.missing == 0
    end

    def solution
      @grid.solution
    end

    def correctly?
      @grid.valid?
    end

    def to_a
      @grid
    end

    def clean
      @grid.each(&:ret_org)
    end

    # Solves sudoku and returns 2D Grid
    def solve
      @grid.solve
    end
  end
end
