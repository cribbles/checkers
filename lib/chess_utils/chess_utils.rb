require_relative 'errors'
require_relative 'modules/renderable'
require_relative 'modules/traversable'
require_relative 'modules/notatable'

module ChessUtils
  include Renderable
  include Traversable
  include Notatable

  SIZE = 8
end
