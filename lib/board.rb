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

  def fill_rows
    (0..2).each          { |row| fill_row(row, :red) }
    (SIZE-3...SIZE).each { |row| fill_row(row, :blue) }
  end

  def add_piece(piece, pos)
    raise 'space not empty' unless empty?(pos)

    self[pos] = piece
  end

  def move_piece(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def remove_piece(piece)
    self[piece.pos] = nil
  end

  def empty?(pos)
    self[pos].nil?
  end

  def piece?(pos)
    !empty?(pos)
  end

  def pieces
    rows.flatten.compact
  end

  def in_range?(pos)
    pos.all? { |coord| coord.between?(0, SIZE - 1) }
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
    board_colors = [:cyan, :light_cyan]

    stringified_rows = rows.map.with_index do |row, index|
      notation = (SIZE - index).to_s.colorize(:light_black)
      board_colors.rotate!

      stringified_row = row.map(&stringify_space).map do |space|
        board_colors.rotate!

        space.colorize(background: board_colors.first)
      end

      "#{notation} #{stringified_row.join} #{notation}"
    end

    header + stringified_rows.join("\n") + header
  end

  private
  attr_reader :rows

  def fill_row(row, color)
    starting_coord = (row.even? ? 0 : 1)

    (starting_coord...SIZE).step(2) do |col|
      pos = [row, col]
      self[pos] = Piece.new(self, pos, color)
    end
  end

  def stringify_space
    -> (space) { space.nil? ? '   ' : space.to_s }
  end
end