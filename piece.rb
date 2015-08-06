require 'colorize'

class Piece
  COLORS = [:red, :blue]

  DELTAS = {
    red:  [[1, -1], [1, 1]],
    blue: [[-1, 1], [-1, -1]]
  }

  attr_reader :pos, :color

  def initialize(board, pos, color)
    raise unless COLORS.include?(color)

    @board = board
    @pos = pos
    @color = color
    @king = false
    @deltas = DELTAS[color]

    board.add_piece(self, pos)
  end

  def inspect
    { color:  color,
      king:   king,
      deltas: deltas }
  end

  def to_s
    "●".colorize(color)
  end

  def red?
    color == :red
  end

  def blue?
    color == :blue
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
