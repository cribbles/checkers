require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_reader :current_player, :board, :red, :blue

  def initialize(players = nil)
    @board = Board.new

    players ||= { red:  HumanPlayer.new(:red)
                  blue: HumanPlayer.new(:blue) }

    @red, @blue = players[:red], players[:blue]
    @current_player = blue
  end

  def play
    board.fill_rows

    until board.won?
      display_board if human_player?
      play_turn
      switch_players!
    end

    winner = board.winner.capitalize.colorize(:winner)
    puts "Game over!\n\nWinner: #{winner}"
  end

  private
  attr_reader :players, :red, :blue
  attr_writer :current_player

  def switch_players!
    self.current_player = (current_player == blue) ? red : blue
  end

  def human_player?
    current_player.is_a?(HumanPlayer)
  end

  def display_board
    system('clear')
    puts board.render
    puts "\n#{current_player}'s turn"
  end

  def play_turn
    moves = []
    moves = current_player.get_moves until moves.any?

    perform_moves(moves)
  rescue InvalidMoveError => e
    puts e.to_s unless e.nil?
    puts "invalid move, try again"
    retry
  end

  def perform_moves(moves)
    start_pos = moves.shift
    start_piece = board[start_pos]

    if !start_piece
      raise InvalidMoveError, "couldn't find piece at starting position"
    elsif start_piece.color != current_player.color
      raise InvalidMoveError, "not your piece!"
    else
      board[start_pos].perform_moves(moves)
    end
  end
end
