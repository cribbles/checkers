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

  def perform_slide(end_pos)
    raise "can't slide to #{end_pos}" unless slide_moves.include?(end_pos)
    raise "slide blocked - maybe try jumping?" if board.piece?(end_pos)

    perform_slide!(end_pos)
  end

  private
  attr_reader :color, :king, :deltas, :board
  attr_writer :pos

  def slide_moves
    deltas.map do |delta|
      row, col = pos
      row_delta, col_delta = delta
      [row + row_delta, col + col_delta]
    end
  end

  def perform_slide!(end_pos)
    board.move_piece(pos, end_pos)
    self.pos = end_pos
  end
end
