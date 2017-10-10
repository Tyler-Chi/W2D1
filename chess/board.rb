require 'colorize'
require_relative 'piece'
require_relative "nullpiece"



class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8){Array.new(8)}
    [0,1,6,7].each do |row|
      @grid[row].map! {|spot| Piece.new}
    end


    (2..5).each { |i| @grid[i].map! {|spot| NullPiece.instance} }
    #singleton
  end

  def move_piece(start_pos,end_pos)
    raise ArgumentError, "no starting piece" if self[start_pos].class != Piece

    self[start_pos],self[end_pos] = self[end_pos],self[start_pos]

  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  # def render
  #   #grid is a 2 dimensional Array
  #   @grid.reverse.each do |row|
  #     row.each do |col|
  #       if col.class == NullPiece
  #         print "[ ]"
  #       else #it is a piece!
  #         print "[P]"
  #       end
  #
  #     end
  #     print "\n"
  #   end
  # end

  STDIN.echo = false
end
