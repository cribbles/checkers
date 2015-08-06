require 'colorize'
require_relative 'modules/traversable'

class Piece
  extend Traversable

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
      deltas: deltas }.inspect
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
    @king
  end

  def king!
    @king = true
  end

  def ally?(piece)
    self.color == piece.color
  end

  def opponent?(piece)
    self.color != piece.color
  end

  def perform_slide(end_pos)
    return false unless slide_moves.include?(end_pos)

    perform_slide!(end_pos)
  end

  def perform_jump(end_pos)
    return false unless jump_moves.include?(end_pos)

    perform_jump!(end_pos)
  end

  def maybe_promote
    row = pos.first
    top_row = 0
    bottom_row = Board::SIZE - 1

    king! if (blue? && row == top_row) || (red? && row == bottom_row)
  end

  protected
  attr_reader :color

  private
  attr_reader :deltas, :board
  attr_writer :pos

  def slide_moves
    slide_moves = []

    deltas.each do |delta|
      slide_pos = self.class.add_coords(pos, delta)
      next if board.piece?(jump_pos) || !board.in_range?(jump_pos)

      slide_moves << slide_pos
    end

    slide_moves
  end

  def jump_moves
    jump_moves = []

    deltas.each do |delta|
      step_pos = self.class.add_coords(pos, delta)
      next unless board.piece?(step_pos) && opponent?(board[step_pos])

      jump_pos = self.class.add_coords(step_pos, delta)
      next if board.piece?(jump_pos) || !board.in_range?(jump_pos)

      jump_moves << jump_pos
    end

    jump_moves
  end

  def perform_slide!(end_pos)
    board.move_piece(pos, end_pos)
    self.pos = end_pos
  end

  def perform_jump!(end_pos)
    opponent_pos = self.class.intermediate_coords(pos, end_pos)
    opponent = board[opponent_pos]

    board.remove_piece(opponent)
    perform_slide!(end_pos)
  end
end
