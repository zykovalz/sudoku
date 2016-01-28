# encoding: utf-8
module Sudoku
  # Time for game
  class TimeGame
    attr_reader :time
    def initialize
      @time = Time.now
      @stop = 0
      @stopped = false
    end

    def reset
      @time = Time.now
      @stopped = false
    end

    def to_i
      @stop
    end

    def now
      return @stop if @stopped
      (Time.now - @time).to_i.abs
    end

    def draw(font, color)
      text = "Čas: #{self}"
      font.draw(text, 500, 50, 2, 1.0, 1.0, color)
    end

    def stop
      @stop = now
      @stopped = true
    end

    def to_s
      Time.at(now).utc.strftime '%H:%M:%S'
    end
  end
end
