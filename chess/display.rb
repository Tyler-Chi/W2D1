require_relative "cursor"
require_relative 'board' #which contains colorize!

class Display

  attr_accessor :board, :cursor

  def initialize(board,cursor)
    @board = board
    @cursor = cursor
  end

  def render
    #grid is a 2 dimensional Array
    (0..7).to_a.reverse.each do |row|
      (0..7).each do |col|
        piece = @board[[row, col]]
        disp = piece.class == NullPiece ? "[ ]" : "[#{piece.symbol}]"

        if [row, col] == @cursor.cursor_pos
          print disp.colorize(:red)
        elsif piece.color == :yellow
          print disp
        elsif piece.color == :white
          print disp.colorize(:blue)
        elsif piece.color == :black
          print disp.colorize(:green)

        end
      end

      print "\n"
    end

  end
end
