require_relative 'piece'
require_relative 'chess_utils/chess_utils'

class HumanPlayer
  include ChessUtils::Notatable

  attr_reader :color

  def initialize(color, board)
    raise unless Piece::COLORS.include?(color)

    @color = color
  end

  def to_s
    color.to_s.capitalize.colorize(color)
  end

  def get_moves
    puts "\nselect your next move(s), e.g. 'd3, e4'"
    print ">"
    moves = gets.chomp.gsub(/ /,'').split(',')

    abort if moves.first =~ ABORT_REGEX
    parse_notation(moves)
  end
end
