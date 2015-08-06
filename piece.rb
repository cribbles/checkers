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

  def ally?(piece)
    self.color == piece.color
  end

  def opponent?(piece)
    self.color != piece.color
  end

  def perform_slide(end_pos)
    raise "can't slide to #{end_pos}" unless slide_moves.include?(end_pos)
    raise "slide blocked - maybe try jumping?" if board.piece?(end_pos)

    perform_slide!(end_pos)
  end

  def perform_jump(end_pos)
    raise "can't jump to #{end_pos}" unless jump_moves.include?(end_pos)

    perform_jump!(end_pos, opponent: valid_jumps[end_pos])
  end

  protected
  attr_reader :color

  private
  attr_reader :king, :deltas, :board
  attr_writer :pos

  def slide_moves
    deltas.map do |delta|
      row, col = pos
      row_delta, col_delta = delta
      [row + row_delta, col + col_delta]
    end
  end

  def jump_moves
    valid_jumps.keys
  end

  def valid_jumps
    valid_jumps = {}

    deltas.each do |delta|
      row, col = pos
      row_delta, col_delta = delta

      step_pos = [row + row_delta, col + col_delta]
      next unless board.piece?(step_pos) && opponent?(board[step_pos])

      jump_pos = [row + (row_delta * 2), col + (col_delta * 2)]
      next if board.piece?(jump_pos)

      valid_jumps.merge!({ jump_pos => board[step_pos] })
    end

    valid_jumps
  end

  def perform_slide!(end_pos)
    board.move_piece(pos, end_pos)
    self.pos = end_pos
  end

  def perform_jump!(end_pos, opponent: opponent)
    board.remove_piece(opponent)
    perform_slide!(end_pos)
  end
end
