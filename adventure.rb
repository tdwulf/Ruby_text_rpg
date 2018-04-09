require "sqlite3"
require_relative "adventure/player"
require_relative "adventure/monster"
require_relative "adventure/npc"
require_relative "adventure/game"
require_relative "adventure/main_db_setup"
require_relative "adventure/player_db_setup"
require_relative "adventure/world_db_setup"
require_relative "adventure/world"
require_relative "adventure/monster_db_setup"
require_relative "adventure/npc_db_setup"
require_relative "adventure/node_db_setup"
require_relative "adventure/node"
require_relative "adventure/item_db_setup"
require_relative "adventure/quest_db_setup"

module RubyAdventure
  ROOT_PATH = File.expand_path('../', File.dirname(__FILE__))
  
  ADVENTURE = Game.new
end


