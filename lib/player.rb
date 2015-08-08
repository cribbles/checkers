require 'byebug'

class HumanPlayer
  attr_reader :color

  def initialize(color)
    raise unless Piece::COLORS.include?(color)

    @color = color
  end

  def to_s
    color.to_s.capitalize.colorize(color)
  end

  def get_moves
    puts "\nselect your next move(s), e.g. 'd3, e4'"
    print ">"
    notation = gets.chomp.gsub(/ /,'').split(',')

    parse(notation)
  rescue UserInputError
    puts "invalid input - try again"
    retry
  end

  private

  def parse(notation)
    notation.map do |move|
      raise UserInputError unless notated?(move)

      notated_row, notated_col = move.chars.reverse
      row = Board::SIZE - notated_row.to_i
      col = 'abcdefgh'.index(notated_col)

      [row, col]
    end
  end

  def notated?(move)
    move =~ /\A[a-h]{1}[1-8]{1}\z/
  end
end

class UserInputError < StandardError
end
