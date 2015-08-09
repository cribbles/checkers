module ChessUtils
  module Traversable
    def intermediate_coords(start_pos, end_pos)
      raise 'incompatible coordinates' if start_pos.count != end_pos.count
      intermediate_pos = []

      end_pos.each_with_index do |end_coord, index|
        start_coord = start_pos[index]
        delta = (end_coord - start_coord) / 2

        intermediate_pos << start_coord + delta
      end

      intermediate_pos
    end

    def add_coords(pos, delta)
      row, col = pos
      row_delta, col_delta = delta

      [row + row_delta, col + col_delta]
    end
  end
end
