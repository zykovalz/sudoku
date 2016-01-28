module Sudoku
  # Result for game
  class Result
    attr_reader :data, :index
    def initialize(name, font)
      @file = name
      @index = 0
      @font = font
      create_data
    end

    def create_data
      text = File.open(@file, 'a+').read
      text.gsub!(/\r\n?/, "\n")
      @data = []
      text.each_line do |line|
        @data << [line.split.first, line.split[1].to_i]
      end
      @data = sort
      @data = @data.take(10)
    end

    def sort
      @data.sort { |a, b| a[1] <=> b[1] }
    end

    def save(time)
      @data << ['Novy', time]
      @index = sort.index(@data[@data.length - 1])
      @data = sort
      @data = @data.take(10)
      @index
    end

    def draw
      @data.each_with_index do |x, i|
        t = Time.at(x[1]).utc.strftime '%H:%M:%S'
        c = Color.new(136, 0, 0)
        c = Color.new(0, 0, 0) if @index == i
        text = "#{i + 1}. #{x[0]} #{t}"
        @font.draw(text, 500, (i + 1) * 25 + 200, 2, 1.0, 1.0, c)
      end
    end

    def write(name)
      return if @index >= @data.length
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
