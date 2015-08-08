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
      elsif
        piece.slide_moves.any?
        possible_slides << explore_slide_moves(piece)
      end
    end

    if possible_jumps.any?
      possible_jumps.sort_by(&:length).last
    else
      possible_slides.sample.sample
    end
  end

  private
  attr_reader :board

  def pieces
    board.pieces.select { |piece| piece.color == self.color }
  end

  def explore_jump_moves(piece, board)
    start_pos = piece.pos
    move_sequence = [start_pos]
    subsequences = []

    piece.jump_moves.each do |end_pos|
      duped_board = board.dup
      duped_piece = duped_board[piece.pos]
      duped_board.move_piece(piece.pos, end_pos)

      if duped_piece.jump_moves.any?
        subsequence = explore_jump_moves(duped_piece, duped_board)
        subsequences << move_sequence + subsequence
      else
        move_sequence << end_pos
      end
    end

    return move_sequence unless subsequences.any?
    move_sequence + subsequences.sort_by(&:length).last
  end

  def explore_slide_moves(piece)
    start_pos = piece.pos

    piece.slide_moves.inject([]) do |slide_moves, end_pos|
      slide_moves << [start_pos, end_pos]
    end
  end
end
