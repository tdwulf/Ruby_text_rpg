require "sqlite3"

module RubyAdventure
	class QuestData
		attr_accessor :show_by_id
		def initialize
				
			begin
				create_quest_data_db
			rescue
			end
			
			#CREATE TABLES 
			create_main_quest_tbl
			
			#UPDATE TABLES
			create_basic_quests
			puts "work.. work...work..."
			
		end
		
		##
		## NODE DB 
		##
		
		def create_quest_data_db
			@quest_data_db = SQLite3::Database.new "adventure/db/quest_data.db"
			#@quest_data_db.results_as_hash = true
		end 
		
		##
		## Quest TABLE
		##
		
		#create an empty db for world locations
		def create_main_quest_tbl
			l_rows = @quest_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS quest_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					decrip varchar(255),
					k_g_goal int,
					k_g_name varchar(30),
					exp_reward int,
					silver_reward int,
					gold_reward int,
					loot_reward varcar(30),
					level int,
					loc varchar(30),
					tod int
				);
			SQL
		end
		
		def create_basic_quests
			begin
				@quest_data_db.execute ("DELETE from quest_data")
			rescue
				puts "discovering items"
			end
			# Execute inserts
			#[ db_name, name, descrip, k_g_goal, k_g_name, exp_reward, silver_reward, gold_reward, loot_reward, level, locale, tod]
			[
				["kill_rats","eRATicate","Kill 10 small rats",10,"small_rat",15,10,0,"kill_rats",0,"new_harbor",2],
				["kill_large_rats","eRATicate II","Kill 5 large rats",5,"large_rat",20,15,0,"kill_rats",1,"new_harbor",0],
				["kill_rat_king","The Rat King","Kill the Rat King in New Harbor",1,"rat_king",30,20,0,"kill_rat_king",1,"new_harbor",2],
				["get_wood","Woody","Gather 15 soft wood",15,"soft_wood",15,10,0,"none",0,"new_harbor",2],
				["get_copper","Copper Miner","Gather 15 copper ore",15,"copper_ore",15,10,0,"none",0,"new_harbor",2],
				["kill_skeletons","Debone","Kill 15 skeletons. Look in the catacombs.",15,"skeleton",15,20,0,"none",1,"new_harbor",2],
				["find_mr_afierin","Mr Afierin","Find Mr Afierin in the catacombs",1,"mr_afierin",20,20,0,"none",0,"new_harbor",2],
				["kill_skeleton_king","Skeleton King","Kill the Skeleton King in Catacombs depth 7",1,"skeleton_king",20,20,0,"kill_rat_king",1,"nhc7",2]
				
			].each do |dbn,n,d,kgg,kgn,exp,sr,gr,loot,lvl,loc,tod|
				@quest_data_db.execute "insert into quest_data values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,kgg,kgn,exp,sr,gr,loot,lvl,loc,tod
			end
		end
		
		
		#query node data
		def get_quest_by_id(id)
			return @quest_data_db.execute( "select * from quest_data where id = ?", id)
		end
		
		def get_quest_loc(loc)
			return @quest_data_db.execute( "select * from quest_data where loc = ?", loc)
		end
		
		def load_quest_data(db_name)
			return @quest_data_db.execute( "select * from quest_data where db_name = ?", db_name)
		end
		def load_quest_data_by_name(db_name)
			return @quest_data_db.execute( "select name from quest_data where db_name = ?", db_name)
		end
		
	end
end
