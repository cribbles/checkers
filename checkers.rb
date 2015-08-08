#!/usr/bin/env ruby

require_relative 'lib/game'

players = {}
board = Board.new
red, blue = "Red".colorize(:red), "Blue".colorize(:blue)

system('clear')
puts "- - - CHECKERS - - -".colorize(:green)

def get_player(board, color)
  formatted_color = color.to_s.capitalize.colorize(color)
  puts "\nWho's playing #{formatted_color} - (H)uman or (C)omputer?"
  print ">"
  input = gets.chomp.downcase[0]

  case input
  when 'h' then player = HumanPlayer
  when 'c' then player = ComputerPlayer
  else
    raise UserInputError
  end

  player.new(color, board)
rescue UserInputError
  retry
end

[:red, :blue].each { |color| players[color] = get_player(board, color) }

Game.new(board, players).play
