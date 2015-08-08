require_relative 'board'
require_relative 'player'

class Game
  attr_reader :current_player, :board, :red, :blue

  def initialize(players = nil)
    players ||= { red:  HumanPlayer.new(:red),
                  blue: HumanPlayer.new(:blue) }

    @board = Board.new
    @red, @blue = players[:red], players[:blue]
    @current_player = blue
  end

  def play
    board.fill_rows

    loop do
      system 'clear'
      puts board.render
      puts "\n#{current_player}'s turn"

      play_turn
      switch_players!
    end
  end

  private
  attr_reader :players, :red, :blue
  attr_writer :current_player

  def switch_players!
    self.current_player = (current_player == blue) ? red : blue
  end

  def play_turn
    moves = current_player.get_moves
    start_pos = moves.shift

    board[start_pos].perform_moves(moves)
  rescue InvalidMoveError
    puts "invalid move, try again"
    retry
  end
end
