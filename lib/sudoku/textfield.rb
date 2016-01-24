
require 'gosu'
module Sudoku
  class TextField < Gosu::TextInput
    INACTIVE_COLOR  = 0xcc666666
    ACTIVE_COLOR    = 0xccff6666
    SELECTION_COLOR = 0xcc0000ff
    CARET_COLOR     = 0xffffffff
    PAD = 5
    attr_reader :x, :y
    def initialize(window, font, x, y)
      super()
      @window = window
      @font = font
      @x = x
      @y = y
      self.text = 'Zadej prezdivku'
    end

    def draw
      self.text = self.text[0..10]
      if @window.text_input == self
        background_color = ACTIVE_COLOR
      else
        background_color = INACTIVE_COLOR
      end
      @window.draw_quad(x - PAD, y - PAD, background_color, x + width + PAD, y - PAD, background_color, x - PAD, y + height + PAD, background_color, x + width + PAD, y + height + PAD, background_color, 0)
      pos_x = x + @font.text_width(self.text[0...self.caret_pos])
      sel_x = x + @font.text_width(seslf.text[0...self.selection_start])
      @window.draw_quad(sel_x, y, SELECTION_COLOR, pos_x, y, SELECTION_COLOR, sel_x, y + height, SELECTION_COLOR, pos_x, y + height, SELECTION_COLOR, 0)
      if @window.text_input == self
        @window.draw_line(pos_x, y, CARET_COLOR, pos_x, y + height, CARET_COLOR, 0)
      end
      @font.draw(self.text, x, y, 0)
    end

    def move_caret(mouse_x)
      1.upto(self.text.length) do |i|
        if mouse_x < x + @font.text_width(text[0...i])
          self.caret_pos = self.selection_start = i - 1
          return true
        end
      end
      self.caret_pos = self.selection_start = self.text.length
    end

    def width
      @font.text_width(self.text)
      150
    end

    def height
      @font.height
    end

    # Hit-test for selecting a text field with the mouse.
    def under_point?(mouse_x, mouse_y)
      mouse_x > x - PAD && mouse_x < x + width + PAD && mouse_y > y - PAD && mouse_y < y + height + PAD
    end
  end
end
