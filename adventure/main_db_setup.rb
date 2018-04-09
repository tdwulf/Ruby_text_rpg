require "sqlite3"

module RubyAdventure
	class GameData
		attr_accessor
		def initialize
			
			begin
				create_game_data_db
			rescue
				puts "Making something out of the void"
			end
			
			#CREATE TABLES 
			create_help_tbl
			create_player_tbl
			
			# UPDATE TABLES
			update_help_tbl
			puts "Finding something helpful for you..."

		end
		
		##
		## GAME_DATA Main DB 
		##
		
		def create_game_data_db
			@game_data_db = SQLite3::Database.new "adventure/db/game_data.db"
			#@game_data_db.results_as_hash = true
		end 
		
		#
		# HELP TABLE  *** Should this move to a text file ??
		#
		def create_help_tbl
			h_rows = @game_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS help_topics (
					id INTEGER PRIMARY KEY,
					menu varchar(30),
					action varchar(30),
					descrip varchar(255)
				);
			SQL
		end
		
		# update help table
		def update_help_tbl
			begin
				@game_data_db.execute ("DELETE from help_topics")
			rescue
				puts "help data reloading"
			end
			# Execute inserts
			[
				["all","help","displays actions/commands for current game state"],
				["main","allhelp","displays all actions/commands regardless of game state"],
				["main","stats", "displays player stats"],
				["main","inv","opens the inventory menu"],
				["main","sinv","shows inventory, without opening inventory menu"],
				["main","look","provides a description of your current location and paths to other areas"],
				["main","walk", "walks around current area looking for monsters, npcs, and items"],
				["main","north", "travels to north path if available"],
				["main","east", "travels to east path if available"],
				["main","south", "travels to south path if available"],
				["main","west", "travels to west path if available"],
				["main","rest", "rests when not in combat (restores hp)"],
				["main","exit", "exits the game"],
				["battle","run", "attempt to run from the fight, if you fail to run away you will be attacked"],
				["battle","attack", "attempt to attack the monster"],
				["battle","eat", "COMMING SOON"],
				["battle","skill#", "COMMING SOON"],
				["inventory","delete", "delete item(s)"],
				["inventory","close", "closes inventory menu"],
				["inventory","consume", "COMMING SOON"],
				["inventory","sell", "COMMING SOON"],
				["gathering","leave", "leaves the node without gathering it"],
				["gathering","gather", "attempts to gather from the node"],
				["crafting","*", "COMMING SOON"],
				["merchant","*", "COMMING SOON"]
			].each do |menu,action,descrip|
				@game_data_db.execute "insert into help_topics values ( ?, ?, ?, ?)", nil, menu,action,descrip
			end
		end
		
		#display help
		def view_all_help
			system "clear" or system "cls"
			puts "-"*50
			puts "Game State -- Command -- Description"
			puts "-"*50
			@game_data_db.execute( "select * from help_topics" ).each do |help|
				puts "#{help[1].to_s} -- #{help[2].to_s} -- #{help[3].to_s}"
			end
			puts "-"*50
		end
		
		def view_help_by_state(game_state)
			system "clear" or system "cls"
			puts "\t\t\t #{game_state.upcase} HELP  "
			puts "-"*50
			puts "Command -- Description"
			puts "-"*50
			@game_data_db.execute( "select * from help_topics where menu = ?",game_state).each do |help|
				puts "#{help[2].to_s} -- #{help[3].to_s}"
			end
			puts "-"*50
			puts " "
			puts " "
			puts "Help will close in 5 seconds"
			sleep 5
		end 
		
		##
		## PLAYER TABLE
		##
		
		#create an empty db for player records
		def create_player_tbl
			p_rows = @game_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS player_data (
					id INTEGER PRIMARY KEY,
					name varchar(30),
					passwd varchar(255)
				);
			SQL
		end
		
		# check if player exits
		def check_player(pname)
			return @game_data_db.execute( "select name from player_data where name = ?", pname )
		end
		
		#check the player db stored password  ## This needs to be enrypted
		def check_pass(pname)
			return @game_data_db.execute( "select passwd from player_data where name = ?", pname )
		end
		
		
		##
		## ADD Data to Tables
		##
		
		#add a new player
		def add_player(pname, passwd)
			@game_data_db.execute("insert into player_data (id, name, passwd) values (?, ?, ?)", nil, pname, passwd)
		end
		
		
	end
end
