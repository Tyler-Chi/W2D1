class Array
  def plus(arr)
    row = self[0]+ arr[0]
    col = self[1] + arr[1]
    [row,col]
  end
end



class Piece
  attr_accessor :moves, :position, :color, :board, :moves_dirs

  #will be passing in the new potential board
  #move_into_check?
    #first update @board with the possible move, based on self and end_pos
    #IF it results in check
    #unupdate the @board
    #return false

  def move_into_check?(end_pos)
    new_board = @board.deep_dup

    #make the move, and then update the board
    current_pos = @position
    new_board[current_pos],new_board[@position] = new_board[@position],new_board[current_pos]
    new_board.update_board
    in_check?(new_board)
  end


  def in_check?(new_board)

    opponent = self.color == :white ? :black : :white

    #FIND YOUR OWN KING!!!
    new_board.update_board
    king_pos = []
    (0..7).each do |row|
      (0..7).each do |col|
        if new_board[row,col].color == self.color && new_board[row,col].class == King
          king_pos = [row,col]
        end
      end
    end
    #now we know where our king is
    (0..7).each do |row|
      (0..7).each do |col|
        potential = new_board[[row,col]]
        if potential.color == opponent
          potential.update_possible_moves
          return true if potential.moves.include?(king_pos)
        end
      end
    end
    false
  end


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
