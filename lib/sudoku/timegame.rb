module Sudoku
  # Time for game
  class TimeGame
    attr_reader :time
    def initialize
      @time = Time.now
      @stop = 0
    end

    def reset
      @time = Time.now
    end

    def to_i
      @stop
    end

    def now
      (Time.now - @time).to_i.abs
    end

    def stop
      @stop = now
    end

    def to_s
      Time.at(now).utc.strftime '%H:%M:%S'
    end
  end
end
