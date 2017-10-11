require_relative 'board'
require_relative 'cursor'
require_relative 'nullpiece'
require_relative 'piece'
require_relative 'display'

A = Board.new
A.populate
m = Cursor.new([0,0],A)
B = Display.new(A,)
B.render
