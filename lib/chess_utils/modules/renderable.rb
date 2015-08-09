module ChessUtils
  module Renderable
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
  end
end
