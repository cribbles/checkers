require 'colorize'

class Piece
  DELTAS = {
    red:    [[1, -1], [1, 1]],
    yellow: [[-1, 1], [-1, -1]]
  }

  def initialize(board, color)
    raise unless [:red, :yellow].include?(color)

    @board = board
    @color = color
    @king = false
    @deltas = DELTAS[color]
  end

  def inspect
    { color:  color,
      king:   king,
      deltas: deltas }
  end

  def to_s
    "O".colorize(:color)
  end

  def red?
    color == red
  end

  def yellow?
    color == yellow
  end

  def king?
    king
  end

  def deltas
    @deltas.dup
  end

  private
  attr_reader :color, :king

  def _deltas
    @deltas
  end
end
