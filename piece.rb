class Piece
  def initialize(color)
    raise unless [:red, :yellow].include?(color)

    @color = color
    @king = false
  end

  def red?
    @color == red
  end

  def yellow?
    @color == yellow
  end
end
