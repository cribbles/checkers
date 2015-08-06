require_relative 'piece'

class Board
  SIZE = 8

  def initialize
    @grid = Array.new(SIZE) { Array.new(SIZE) }
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    grid[row][col] = mark
  end

  def fill_grid
    (0..2).each { |row| populate_row(row, :red) }
    (SIZE-3...SIZE).each { |row| populate_row(row, :yellow) }
  end

  private
  attr_reader :grid

  def fill_row(row, color)
    starting_coord = (row.even? ? 0 : 1)

    (starting_coord...SIZE).step(2) do |col|
      pos = [row, col]
      self[pos] = Piece.new(self, :red)
    end
  end
end
