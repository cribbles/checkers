class Piece
  MOVES = {
    red:    [[1, -1], [1, 1]],
    yellow: [[-1, 1], [-1, -1]]
  }

  attr_reader :moves

  def initialize(color)
    raise unless [:red, :yellow].include?(color)

    @color = color
    @king = false
    @moves = MOVES[color]
  end

  def red?
    @color == red
  end

  def yellow?
    @color == yellow
  end
end
