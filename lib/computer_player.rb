require_relative 'piece'

class ComputerPlayer
  attr_reader :color

  def initialize(color, board)
    raise unless Piece::COLORS.include?(color)

    @color = color
    @board = board
  end

  def to_s
    color.to_s.capitalize.colorize(color)
  end

  def get_moves
    possible_jumps = []
    possible_slides = []

    pieces.each do |piece|
      if piece.jump_moves.any?
        possible_jumps << explore_jump_moves(piece, board)
      elsif possible_jumps.empty?
        possible_slides << explore_slide_moves(piece)
      end
    end

    possible_slides.flatten!(1)
    best_moves(possible_jumps, possible_slides)
  end

  private
  attr_reader :board

  def pieces
    board.pieces.select { |piece| piece.color == self.color }
  end

  def opponent_pieces
    board.pieces.reject { |piece| piece.color == self.color }
  end

  def explore_jump_moves(piece, board)
    start_pos = piece.pos
    jump_sequences = []

    piece.jump_moves.each do |end_pos|
      duped_board = board.dup
      duped_piece = duped_board[piece.pos]
      duped_piece.perform_moves([end_pos])

      if duped_piece.jump_moves.any?
        jump_sequences << explore_jump_moves(duped_piece, duped_board)
      end
    end

    if jump_sequences.any?
      [start_pos] + jump_sequences.sort_by(&:length).last
    else
      [start_pos, piece.jump_moves.sample]
    end
  end

  def explore_slide_moves(piece)
    start_pos = piece.pos

    piece.slide_moves.each_with_object([]) do |end_pos, slide_moves|
      slide_moves << [start_pos, end_pos]
    end
  end

  def best_moves(possible_jumps, possible_slides)
    if possible_jumps.any?
      possible_jumps.sort_by(&:length).last
    else
      best_slide(possible_slides)
    end
  end

  def best_slide(possible_slides)
    safe_slides = possible_slides.select do |slide|
      end_pos = slide.last
      safe_landing_pos?(end_pos)
    end

    if safe_slides.any?
      safe_slides.sample
    else
      possible_slides.sample
    end
  end

  def safe_landing_pos?(end_pos)
    opponent_pieces.none? do |piece|
      piece.slide_moves.any? do |slide_pos|
        slide_pos == end_pos
      end
    end
  end
end
