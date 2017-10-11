require_relative 'nullpiece'
require_relative 'cursor'
require 'colorize'

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8){Array.new(8)}

  end

  def populate

    (0..7).each do |col|
       @grid[1][col]= Pawn.new([0,0],self, :white)
       @grid[6][col]= Pawn.new([0,0],self, :black)
    end
    #rooks
    [[0,0],[0,7]].each do |position|
      self[position] = Rook.new(position,self,:white)
    end
    [[7,0],[7,7]].each do |position|
      self[position] = Rook.new(position,self,:black)
    end

    #knights
    [[0,1],[0,6]].each do |position|
      self[position] = Knight.new(position,self,:white)
    end
    [[7,1],[7,6]].each do |position|
      self[position] = Knight.new(position,self,:black)
    end
    #bishops
    [[0,2],[0,5]].each do |position|
      self[position] = Bishop.new(position,self,:white)
    end
    [[7,2],[7,5]].each do |position|
      self[position] = Bishop.new(position,self,:black)
    end

    self[[0,3]] = Queen.new([0,3],self,:white)
    self[[7,3]] = Queen.new([7,3],self,:black)
    self[[0,4]] = King.new([0,4],self,:white)
    self[[7,4]] = King.new([7,3],self,:black)

    #null pieces!

    (2..5).each { |i| @grid[i].map! {|spot| NullPiece.instance } }
    self.update_board
  end

  def update_board
    (0..7).each do |row|
      (0..7).each do |col|
        self[[row,col]].position = [row,col] unless self[[row,col]].class == NullPiece
      end
    end
    (0..7).each do |row|
      (0..7).each do |col|
        self[[row,col]].board = self unless self[[row,col]].class == NullPiece
      end
    end

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


class Array
  def plus(arr)
    row = self[0]+ arr[0]
    col = self[1] + arr[1]
    [row,col]
  end
end



class Piece
  attr_accessor :moves, :position, :color, :board, :moves_dirs


  def initialize(position, board, color)
    @moves = []
    @position = position #a 1d array of 2 elements
    @board = board
    @color = color #the an instance of board class
  end

  def out_of_bounds?(pos)
    return true if (!pos[0].between?(0,7) || !pos[1].between?(0,7))
    return false
  end

  def valid_move?(potential_pos)
    return false if out_of_bounds?(potential_pos)

    return false if @board[potential_pos].color == self.color
    true

  end


end

module Sliding
  def update_possible_moves
    @moves = []
    diagonal_shift = [[1,1],[1,-1],[-1,1],[-1,-1]]
    horizontal_shift = [[1,0],[-1,0],[0,1],[0,-1]]

    if self.moves_dirs.include?(:diagonal)
      diagonal_shift.each do |shift|
        ending_pos = @position.plus(shift)
        while valid_move?(ending_pos)
          @moves << ending_pos
          ending_pos = ending_pos.plus(shift)
        end

      end
    end

    if self.moves_dirs.include?(:horizontal)
      horizontal_shift.each do |shift|
        ending_pos = @position.plus(shift)
        while valid_move?(ending_pos)
          @moves << ending_pos
          ending_pos = ending_pos.plus(shift)
        end

      end
    end
  end
end



module Stepping
  def update_possible_moves
    @moves = []
  #for King's move
    walking_shifts = []
    [-1,0,1].each do |hor_shift|
      [-1,0,1].each do |vert_shift|
        walking_shifts << [hor_shift,vert_shift] unless [hor_shift,vert_shift] == [0,0]
      end
    end

    #for Knight's move
    hopping_shifts = []
    [-2,-1,1,2].each do |side1|
      [-2,-1,1,2].each do |side2|
        hopping_shifts << [side1,side2] if side1.abs + side2.abs == 3
      end
    end


    potential_moves = self.move_dirs == [:walking] ? walking_shifts : hopping_shifts
    potential_moves.each do |possible_shift|
      ending_pos = @position.plus(possible_shift)
      @moves << ending_pos if valid_move?(ending_pos)
    end
  end
end

class Pawn < Piece
  attr_reader :symbol
  def initialize(position, board, color)
    @symbol = "P"
    super
  end

  def update_possible_moves
    @moves = []
    possible_shift = []
    direction = self.color == :white ? 1 : -1

    if self.color == :white && @position[0] == 1
      possible_shift << [2, 0]
    end

    if self.color != :white && @position[0] == 6
      possible_shift << [-2, 0]
    end
    #this takes care of the starting position

    possible_shift << [1 * direction, 0]
    [[1 * direction, -1], [1 * direction, 1]].each do |possible_attack|
      thatspot = @board[@position.plus(possible_attack)]
      if thatspot.class == Piece && thatspot.color != self.color
        possible_shift << @position.plus(possible_attack)
      end
    end

    possible_shift.each do |pawn_move|
      ending_pos = @position.plus(pawn_move)
      @moves << ending_pos if valid_move?(ending_pos)
    end

  end

end


class King < Piece
  include Stepping
  attr_reader :symbol
  def initialize(position, board, color)
    super
    @moves_dirs = [:walking]
    @symbol = "K"
  end
end

class Knight < Piece
  include Stepping
  attr_reader :symbol
  def initialize(position, board, color)
    super
    @moves_dirs = [:hopping]
    @symbol = "H"
  end



end


class Bishop < Piece
  include Sliding
  attr_reader :symbol
  def initialize(position, board, color)
    super
    @moves_dirs = [:diagonal]
    @symbol = "B"
  end

end

class Rook < Piece
  include Sliding
  attr_reader :symbol
  def initialize(position, board, color)
    @moves_dirs = [:horizontal]
    super
    @symbol = "R"
  end
end

class Queen < Piece
  include Sliding
  attr_reader :symbol
  def initialize(position, board, color)
    @moves_dirs = [:horizontal, :diagonal]
    super
    @symbol = "Q"
  end
end
