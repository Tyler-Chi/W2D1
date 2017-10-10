require_relative "cursor"
require_relative 'board' #which contains colorize!

class Display

  attr_accessor :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    #grid is a 2 dimensional Array
    (0..7).to_a.reverse.each do |row|
      (0..7).each do |col|
        piece = @board[[row, col]]
        disp = (piece.class == NullPiece) ? "[ ]" : "[P]"

        if [row, col] == @cursor.cursor_pos
          print disp.colorize(:red)
        else
          print disp.colorize(:blue)
        end
      end

      print "\n"
    end

  end
end
