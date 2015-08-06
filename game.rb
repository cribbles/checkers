require_relative 'board'

class Game
  attr_reader :current_player

  def initialize(players = nil)
    players ||= {red: HumanPlayer.new(:red), blue: HumanPlayer.new(:blue)}

    @red, @blue = players.first, players.last
    @current_player = blue
  end

  def switch_players!
    self.current_player = (current_player == blue) ? red : blue
  end

  private
  attr_reader :players, :red, :blue
end
