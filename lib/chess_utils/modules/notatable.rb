module ChessUtils
  module Notatable
    ABORT_REGEX = /\Aq\z|\Aquit\z|\Aexit\z/

    private

    def parse_notation(notation)
      notation.map do |move|
        raise InvalidMoveError unless notated?(move)

        notated_row, notated_col = move.chars.reverse
        row = SIZE - notated_row.to_i
        col = 'abcdefgh'.index(notated_col)

        [row, col]
      end
    end

    def notated?(move)
      move =~ /\A[a-h]{1}[1-#{SIZE}]{1}\z/
    end
  end
end
