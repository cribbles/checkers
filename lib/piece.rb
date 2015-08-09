require 'byebug'
require 'colorize'
require_relative 'chess_utils/chess_utils'

class Piece
  extend ChessUtils::Traversable

  COLORS = [:red, :blue]

  DELTAS = {
    red:  [[ 1, -1], [ 1,  1]],
    blue: [[-1,  1], [-1, -1]]
  }

  attr_reader :color
  attr_accessor :pos

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
      pos:    pos,
      king:   king?,
      deltas: deltas }.inspect
  end

  def to_s
    piece = (king? ? " ♚ " : " ● ")
    piece.colorize(color)
  end

  def perform_moves(move_sequence)
    raise InvalidMoveError if !valid_move_seq?(move_sequence)

    perform_moves!(move_sequence)
  end

  def slide_moves
    slide_moves = []

    deltas.each do |delta|
      slide_pos = self.class.add_coords(pos, delta)
      next unless empty_space?(slide_pos)

      slide_moves << slide_pos
    end

    slide_moves
  end

  def jump_moves
    jump_moves = []

    deltas.each do |delta|
      step_pos = self.class.add_coords(pos, delta)
      next unless opponent?(step_pos)

      jump_pos = self.class.add_coords(step_pos, delta)
      next unless empty_space?(jump_pos)

      jump_moves << jump_pos
    end

    jump_moves
  end

  def maybe_promote
    row = pos.first
    top_row = 0
    bottom_row = Board::SIZE - 1

    promote if (blue? && row == top_row) || (red? && row == bottom_row)
  end

  protected
  attr_reader :board

  def red?
    color == :red
  end

  def blue?
    color == :blue
  end

  def king?
    @king
  end

  def ally?(piece)
    self.color == piece.color
  end

  def empty_space?(end_pos)
    board.in_range?(end_pos) && board.empty?(end_pos)
  end

  def opponent?(end_pos)
    if board.in_range?(end_pos) && board.piece?(end_pos)
      piece = board[end_pos]
      piece.color != self.color
    else
      false
    end
  end

  def perform_slide(end_pos)
    return false unless slide_moves.include?(end_pos)

    perform_slide!(end_pos)
  end

  def perform_jump(end_pos)
    return false unless jump_moves.include?(end_pos)

    perform_jump!(end_pos)
  end

  def perform_moves!(move_sequence)
    case move_sequence.length <=> 1
    when -1
      false
    when 0
      end_pos = move_sequence.first
      perform_slide(end_pos) || perform_jump(end_pos)
    when 1
      move_sequence.each do |end_pos|
        return false unless perform_jump(end_pos)
      end

      true
    end
  end

  private
  attr_reader :deltas, :board

  def promote
    @king = true

    DELTAS[opponent].each { |delta| deltas << delta }
  end

  def opponent
    COLORS.reject { |color| color == self.color }.first
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

  def valid_move_seq?(move_sequence)
    duped_board = board.dup
    duped_piece = duped_board[pos]

    duped_piece.perform_moves!(move_sequence)
  end
end
