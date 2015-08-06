class Board
  SIZE = 8

  def initialize
    @grid = Array.new(SIZE) { Array.new(SIZE) }
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, mark)
    x, y = pos
    grid[x][y] = mark
  end

  private
  attr_reader :grid
end
