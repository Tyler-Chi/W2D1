require "singleton"

class NullPiece
  attr_reader :color

  def initialize(color = :yellow)
    @color = color
  end
  include Singleton
end
