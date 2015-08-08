require_relative 'piece'

class Board
  SIZE = 8

  def initialize
    @rows = Array.new(SIZE) { Array.new(SIZE) }
  end

  def [](pos)
    row, col = pos
    rows[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    rows[row][col] = mark
  end

  def in_range?(pos)
    pos.all? { |coord| coord.between?(0, SIZE - 1) }
  end

  def fill_rows
    (0..2).each          { |row| fill_row(row, :red) }
    (SIZE-3...SIZE).each { |row| fill_row(row, :blue) }
  end

  def add_piece(piece, pos)
    raise 'space not empty' unless empty?(pos)

    self[pos] = piece
  end

  def move_piece(start_pos, end_pos)
    piece = self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def remove_piece(piece)
    self[piece.pos] = nil
  end

  def empty?(pos)
    return false unless in_range?(pos)

    self[pos].nil?
  end

  def piece?(pos)
    return false unless in_range?(pos)

    !empty?(pos)
  end

  def pieces
    rows.flatten.compact
  end

  def won?
    pieces.map(&:color).uniq.one?
  end

  def winner
    pieces.first.color
  end

  def dup
    duped_board = self.class.new

    pieces.each do |piece|
      Piece.new(duped_board, piece.pos, piece.color)
    end

    duped_board
  end

  def render
    header = "\n   a  b  c  d  e  f  g  h   \n".colorize(:light_black)

    rows = self.rows.map.with_index do |row, row_index|
      notation = (SIZE - row_index).to_s.colorize(:light_black)
      spaces = row.map { |space| space.nil? ? '   ' : space.to_s }

      spaces.map!.with_index do |space, space_index|
        parity = row_index + space_index
        color = (parity.even? ? :cyan : :light_cyan)

        space.colorize(background: color)
      end

      "#{notation} #{spaces.join} #{notation}"
    end

    header + rows.join("\n") + header
  end

  protected
  attr_reader :rows

  private

  def fill_row(row, color)
    starting_coord = (row.even? ? 0 : 1)

    (starting_coord...SIZE).step(2) do |col|
      pos = [row, col]
      self[pos] = Piece.new(self, pos, color)
    end
  end
end
