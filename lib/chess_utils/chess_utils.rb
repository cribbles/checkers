require 'colorize'
require_relative 'errors'
require_relative 'modules/renderable'
require_relative 'modules/traversable'
require_relative 'modules/notatable'

module ChessUtils
  include Renderable
  include Traversable
  include Notatable

  SIZE = 8

  WHITE_PIECES = {
    king:   " ♔ ",
    queen:  " ♕ ",
    rook:   " ♖ ",
    bishop: " ♗ ",
    knight: " ♘ ",
    pawn:   " ♙ "
  }

  BLACK_PIECES = {
    king:   " ♚ ",
    queen:  " ♛ ",
    rook:   " ♜ ",
    bishop: " ♝ ",
    knight: " ♞ ",
    pawn:   " ♟ "
  }

  STARTING_POSITIONS = {
    0 => :rook,
    1 => :knight,
    2 => :bishop,
    3 => :queen,
    4 => :king,
    5 => :bishop,
    6 => :knight,
    7 => :rook
  }

  DELTAS = {
    diagonals: [
      [-1, -1],
      [ 1,  1],
      [ 1, -1],
      [-1,  1]
    ],
    cardinals: [
      [ 1,  0],
      [ 0,  1],
      [-1,  0],
      [ 0, -1]
    ],
    knights: [
      [-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]
    ],
    white_pawns: [
      [-1, 0],
      [-2, 0]
    ],
    white_pawns_attack: [
      [ -1,  1],
      [ -1, -1]
    ],
    black_pawns: [
      [ 1, 0],
      [ 2, 0]
    ],
    black_pawns_attack: [
      [ 1, -1],
      [ 1,  1]
    ]
  }
end
