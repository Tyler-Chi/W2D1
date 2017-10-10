require_relative 'board'
require_relative 'cursor'
require_relative 'nullpiece'
require_relative 'piece'
require_relative 'display'

new_board = Board.new
new_display = Display.new(new_board)
new_display.render
