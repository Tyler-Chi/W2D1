require 'colorize'
require_relative 'piece'
require_relative "nullpiece"



class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8){Array.new(8)}

  end

  def deep_dup
    #first create a new board
    new_board = Board.new
    (0..7).each do |row|
      (0..7).each do |col|
        piece = @grid[row][col]
        #first check if its a nullpiece
        if piece.class == NullPiece
          new_board[row,col] = Nullpiece.instance
        else #b/c its not a nullpiece, that means its a REAL piece
          new_board[row,col] = piece.class.new([row,col],piece.board,piece.color)
        end
      end
    end


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
    raise ArgumentError, "no starting piece" if self[start_pos].class == NullPiece

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
