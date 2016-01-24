module Sudoku
  # Result for game
  class Result
    attr_reader :data, :index
    def initialize(name)
      @file = ENV['HOME'] + '/' + name
      text = File.open(@file, 'a+').read
      text.gsub!(/\r\n?/, "\n")
      @data = []
      text.each_line do |line|
        @data << [line.split.first, line.split[1].to_i]
      end
      sort
      @data = @data.take(10) if @data.length > 10
      @index = 0
    end

    def sort
      @data.sort { |a, b| a[1] <=> b[1] }
    end

    def save(time)
      @data << ['Novy', time]
      @index = sort.index(@data[@data.length - 1])
      @data = sort
      @data = @data.take(10)
    end

    def write(name)
      @data[@index][0] = name
      File.open(@file, 'a+') do |f|
        f.write("#{@data[@index][0]} #{@data[@index][1]}\n")
      end
    end

    def to_s
      string = ''
      @data.each do |x|
        t = Time.at(x[1]).utc.strftime '%H:%M:%S'
        string += "#{x[0]} #{t}\n"
      end
      string
    end
  end
end
