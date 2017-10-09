require 'colorize'

class NullPiece

end

class Piece


end


class Board
  def initialize
    @grid = Array.new(8){Array.new(8)}

    @grid[0].map! {|spot| Piece.new}
    @grid[1].map! {|spot| Piece.new}
    @grid[6].map! {|spot| Piece.new}
    @grid[7].map! {|spot| Piece.new}
    (2..5).each { |i| @grid[i].map! {|spot| NullPiece.new} }

  end

  def move_piece(start_pos,end_pos)
    begin

      raise ArgumentError, "no starting piece" if self[start_pos].class != Piece
      # raise ArgumentError, "invalid destination" #unless valid_move()
    rescue
      puts "invalid starting piece, please try again!"
      #reset start_pos and end_pos
      start_pos,end_pos = gets.chomp.split(",").map(&:to_i)
    retry
    end

    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.new
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def render
    #grid is a 2 dimensional Array
    @grid.reverse.each do |row|
      row.each do |col|
        if col.class == NullPiece
          print "[ ]"
        else #it is a piece!
          print "[P]"
        end

      end
      print "\n"
    end
  end
  
  STDIN.echo = false
end
